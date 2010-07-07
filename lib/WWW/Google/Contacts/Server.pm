package WWW::Google::Contacts::Server;

use MooseX::Singleton;
use LWP::UserAgent;
use Net::Google::AuthSub;
use Carp qw( croak );

has ua => (
    is        => 'ro',
    default   => sub { LWP::UserAgent->new },
);

has authsub => (
    is         => 'ro',
    lazy_build => 1,
);

has username => (
    isa        => 'Str',
    is         => 'ro',
    required   => 1,
);

has password => (
    isa        => 'Str',
    is         => 'ro',
    required   => 1,
);

has gdata_version => (
    isa       => 'Str',
    is        => 'ro',
    default   => '3.0',
);

sub _build_authsub {
    my $self = shift;

    my $auth = Net::Google::AuthSub->new(service => 'cp');
    my $res = $auth->login($self->username, $self->password);
    unless ( $res and $res->is_success ) {
        croak "Authentication failed";
    }
    return $auth;
}

sub authenticate {
    my $self = shift;
    return 1 if ( $self->authsub );
}

sub get {
    my ($self, $id) = @_;
    my %headers = $self->authsub->auth_params;
    $headers{'GData-Version'} = $self->gdata_version;
    return $self->ua->get( $id, %headers );
}

sub post {
    my ($self, $id, $content) = @_;

    my %headers = $self->authsub->auth_params;
    $headers{'Content-Type'} = 'application/atom+xml';
    $headers{'GData-Version'} = $self->gdata_version;
    my $res = $self->ua->post( $id, %headers, Content => $content );
    return $res;
}

sub put {
    my ($self, $id, $content) = @_;

    my %headers = $self->authsub->auth_params;
    $headers{'Content-Type'} = 'application/atom+xml';
    $headers{'GData-Version'} = $self->gdata_version;
    $headers{'If-Match'} = '*';
    $headers{'X-HTTP-Method-Override'} = 'PUT';
    my $res = $self->ua->post( $id, %headers, Content => $content );
    return $res;
}

sub delete {
    my ($self, $id) = @_;

    my %headers = $self->authsub->auth_params;
    $headers{'If-Match'} = '*';
    $headers{'X-HTTP-Method-Override'} = 'DELETE';
    $headers{'GData-Version'} = $self->gdata_version;
    my $res = $self->ua->post($id, %headers);
    return $res;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
