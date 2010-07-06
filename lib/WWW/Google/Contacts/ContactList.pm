package WWW::Google::Contacts::ContactList;

use Moose;
use MooseX::Types::Moose qw( ArrayRef );
use WWW::Google::Contacts::Contact;
use WWW::Google::Contacts::Server;
use Carp qw( croak );
use XML::Simple ();
use URI::Escape;

extends 'WWW::Google::Contacts::Base';

has contacts => (
    isa        => ArrayRef,
    is         => 'rw',
    lazy_build => 1,
);

#####

has server => (
    is        => 'ro',
    default   => sub { WWW::Google::Contacts::Server->instance },
);

sub _build_contacts {
    my $self = shift;

    my $args = {};
    $args->{'alt'} = 'atom'; # must be atom
    $args->{'max-results'} ||= 9999;
    my $group = delete $args->{group} || 'full';
    my $url = sprintf( 'http://www.google.com/m8/feeds/contacts/default/%s?v=3.0', uri_escape($group) );
    foreach my $key (keys %$args) {
        $url .= '&' . uri_escape($key) . '=' . uri_escape($args->{$key});
    }
    my $res = $self->server->get( $url );
    my $content = $res->content;
    my $xmls = XML::Simple->new;
    my $data = $xmls->XMLin($content, SuppressEmpty => undef);
    # get the id in there...
    my $array = [ map { { %{ $data->{ entry }{ $_ } }, id => $_ } } keys %{ $data->{ entry } } ];
    return $array;
}

sub next {
    my $self = shift;
    return undef unless ( $self->contacts );
    my $next = shift @{ $self->contacts };
    my $contact = WWW::Google::Contacts::Contact->new();
    return $contact->set_from_server( $next );
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
