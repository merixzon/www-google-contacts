package WWW::Google::Contacts::Roles::List;

use Moose::Role;
use MooseX::Types::Moose qw( ArrayRef );
use Carp qw( croak );
use XML::Simple ();
use URI::Escape;

requires 'baseurl';

has elements => (
    isa        => ArrayRef,
    is         => 'rw',
    lazy_build => 1,
);

has server => (
    is         => 'ro',
    required   => 1,
);

sub _build_elements {
    my $self = shift;

    my $args = {};
    $args->{'alt'} = 'atom'; # must be atom
    $args->{'max-results'} ||= 9999;
    my $group = delete $args->{group} || 'full';
    my $url = sprintf( '%s/%s?v=3.0', $self->baseurl, uri_escape($group) );
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

1;
