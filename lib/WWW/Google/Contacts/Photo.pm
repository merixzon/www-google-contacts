package WWW::Google::Contacts::Photo;

use Moose;
use MooseX::Types::Moose qw( Str );
use WWW::Google::Contacts::Server;

use File::Slurp qw( read_file );

extends 'WWW::Google::Contacts::Base';

has server => ( is => 'ro', required => 1 );

has rel => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'rel',
    required  => 1,
);

has type => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'type',
    required  => 1,
);

has href => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'href',
    required  => 1,
);

has etag => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:etag',
    predicate => 'has_etag',
);

has content => (
    isa        => Str,
    is         => 'rw',
    lazy_build => 1,
);

sub exists {
    my $self = shift;
    return undef unless $self->etag;
    1;
}

sub _build_content {
    my ($self) = shift;
    return undef unless $self->etag;
    my $res = $self->server->get( $self->href );
    return $res->content;
}

sub to_file {
    my ($self, $filename) = @_;

    my $content = $self->content;
    die "There is no photo" unless $content;
    open (my $fh, ">", $filename) or die "Can't write to file [$filename]: $!";
    print {$fh} $content;
    close ($fh) or die "Can't close file [$filename]: $!";
}

sub from_file {
    my ($self, $filename) = @_;

    my $content = read_file( $filename, binmode => ':raw' );
    $self->content( $content );
}

sub create_or_update {
    my $self = shift;
    $self->server->put( $self->href, $self->etag, "image/*", $self->content );
}

sub create { $_[0]->create_or_update }
sub update { $_[0]->create_or_update }
sub delete {
    my $self = shift;
    $self->server->delete( $self->href, $self->etag);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
