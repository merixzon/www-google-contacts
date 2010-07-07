package WWW::Google::Contacts::Group;

use Moose;
use MooseX::Types::Moose qw( Str );
use WWW::Google::Contacts::Types qw(
                                       Category
                               );

use WWW::Google::Contacts::Meta::Attribute::Trait::XmlField;

sub create_url { 'http://www.google.com/m8/feeds/groups/default/full' }

extends 'WWW::Google::Contacts::Base';

with 'WWW::Google::Contacts::Roles::CRUD';

has id => (
    isa        => Str,
    is         => 'ro',
    writer     => '_set_id',
    predicate  => 'has_id',
);

has category => (
    isa        => Category,
    is         => 'rw',
    predicate  => 'has_category',
    traits     => [ 'XmlField' ],
    xml_key    => 'category',
    default    => sub { undef },
    coerce     => 1,
);

has title => (
    isa        => Str,
    is         => 'rw',
    predicate  => 'has_title',
    traits     => [ 'XmlField' ],
    xml_key    => 'title',
    is_element => 1,
);

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
