package WWW::Google::Contacts::Type::Birthday;

use Moose;
use MooseX::Types::Moose qw( Str );
use WWW::Google::Contacts::Meta::Attribute::Trait::XmlField;

extends 'WWW::Google::Contacts::Type::Base';

has when => (
    isa        => Str,
    is         => 'rw',
    traits     => [ 'XmlField' ],
    xml_key    => 'when',
    predicate  => 'has_when',
);

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
