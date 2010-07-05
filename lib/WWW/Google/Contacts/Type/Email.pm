package WWW::Google::Contacts::Type::Email;

use Moose;
use MooseX::Types::Moose qw( Str );
use WWW::Google::Contacts::Types qw( Rel XmlBool );
use WWW::Google::Contacts::Meta::Attribute::Trait;

extends 'WWW::Google::Contacts::Type::Base';

has type => (
    isa       => Rel,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'rel',
    predicate => 'has_type',
    coerce    => 1,
);

has value => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'address',
    predicate => 'has_value',
    required  => 1,
);

has primary => (
    isa       => XmlBool,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    predicate => 'has_primary',
    xml_key   => 'primary',
    to_xml    => sub { my $val = shift; return "true" if $val == 1; return "false" },
    default   => sub { 0 },
    coerce    => 1,
);

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
