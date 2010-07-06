package WWW::Google::Contacts::Type::PostalAddress;

use Moose;
use MooseX::Types::Moose qw( Str );
use WWW::Google::Contacts::InternalTypes qw( Rel XmlBool );
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

has mail_class => (
    isa       => Rel,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'mailClass',
    predicate => 'has_mail_class',
    coerce    => 1,
);

has usage => (
    isa       => Rel,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'usage',
    predicate => 'has_usage',
    coerce    => 1,
);

has label => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'label',
    predicate => 'has_label',
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

has agent => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:agent',
    predicate => 'has_agent',
    is_element => 1,
);

has house_name => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:housename',
    predicate => 'has_house_name',
    is_element => 1,
);

has street => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:street',
    predicate => 'has_street',
    is_element => 1,
);

has pobox => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:pobox',
    predicate => 'has_pobox',
    is_element => 1,
);

has neighborhood => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:neighborhood',
    predicate => 'has_neighborhood',
    is_element => 1,
);

has city => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:city',
    predicate => 'has_city',
    is_element => 1,
);

has subregion => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:subregion',
    predicate => 'has_subregion',
    is_element => 1,
);

has region => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:region',
    predicate => 'has_region',
    is_element => 1,
);

has postcode => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:postcode',
    predicate => 'has_postcode',
    is_element => 1,
);

has country => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:country',
    predicate => 'has_country',
    is_element => 1,
);

has formatted => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:formattedAddress',
    predicate => 'has_formatted',
    is_element => 1,
);

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
