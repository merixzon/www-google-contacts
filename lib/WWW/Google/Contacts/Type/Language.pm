package WWW::Google::Contacts::Type::Language;

use Moose;
use MooseX::Types::Moose qw( Str );
use WWW::Google::Contacts::Meta::Attribute::Trait::XmlField;

extends 'WWW::Google::Contacts::Type::Base';

has code => (
    isa       => Str,
    is        => 'rw',
    traits    => [ 'XmlField' ],
    xml_key   => 'code',
    predicate => 'has_code',
    required  => 1,
);

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
