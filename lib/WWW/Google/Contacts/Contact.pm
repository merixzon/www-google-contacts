package WWW::Google::Contacts::Contact;

use Moose;
use MooseX::Types::Moose qw( Str );
use WWW::Google::Contacts::Types qw(
                                       Category
                                       Name
                                       PhoneNumber     ArrayRefOfPhoneNumber
                                       Email           ArrayRefOfEmail
                                       IM              ArrayRefOfIM
                                       Organization    ArrayRefOfOrganization
                                       PostalAddress   ArrayRefOfPostalAddress
                                       CalendarLink    ArrayRefOfCalendarLink
                                       Birthday
                                       ContactEvent    ArrayRefOfContactEvent
                                       ExternalId      ArrayRefOfExternalId
                                       Gender
                                       GroupMembership ArrayRefOfGroupMembership
                                       Hobby           ArrayRefOfHobby
                                       Jot             ArrayRefOfJot
                                       Language        ArrayRefOfLanguage
                                       Priority
                                       Sensitivity
                                       Relation        ArrayRefOfRelation
                                       UserDefined     ArrayRefOfUserDefined
                                       Website         ArrayRefOfWebsite
                               );
use WWW::Google::Contacts::Meta::Attribute::Trait::XmlField;

sub create_url { 'http://www.google.com/m8/feeds/contacts/default/full' }

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

has notes => (
    isa        => Str,
    is         => 'rw',
    predicate  => 'has_notes',
    traits     => [ 'XmlField' ],
    xml_key    => 'content',
    is_element => 1,
);

has name => (
    isa        => Name,
    is         => 'rw',
    predicate  => 'has_name',
    traits     => [ 'XmlField' ],
    xml_key    => 'gd:name',
    handles    => [qw( given_name additional_name family_name
                       name_prefix name_suffix full_name )],
    default    => sub { undef }, # empty Name object, so handles will work
    coerce     => 1,
);

has phone_number => (
    isa        => ArrayRefOfPhoneNumber,
    is         => 'rw',
    predicate  => 'has_phone_number',
    traits     => [ 'XmlField' ],
    xml_key    => 'gd:phoneNumber',
    coerce     => 1,
);

has email => (
    isa        => ArrayRefOfEmail,
    is         => 'rw',
    predicate  => 'has_email',
    traits     => [ 'XmlField' ],
    xml_key    => 'gd:email',
    coerce     => 1,
);

has im => (
    isa        => ArrayRefOfIM,
    is         => 'rw',
    predicate  => 'has_im',
    traits     => [ 'XmlField' ],
    xml_key    => 'gd:im',
    coerce     => 1,
);

has organization => (
    isa        => ArrayRefOfOrganization,
    is         => 'rw',
    predicate  => 'has_organization',
    traits     => [ 'XmlField' ],
    xml_key    => 'gd:organization',
    coerce     => 1,
);

has postal_address => (
    isa        => ArrayRefOfPostalAddress,
    is         => 'rw',
    predicate  => 'has_postal_address',
    traits     => [ 'XmlField' ],
    xml_key    => 'gd:structuredPostalAddress',
    coerce     => 1,
);

has billing_information => (
    isa        => Str,
    is         => 'rw',
    predicate  => 'has_billing_information',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:billingInformation',
    is_element => 1,
);

has birthday => (
    isa        => Birthday,
    is         => 'rw',
    predicate  => 'has_birthday',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:birthday',
    is_element => 1,
    coerce     => 1,
);

has calendar_link => (
    isa        => ArrayRefOfCalendarLink,
    is         => 'rw',
    predicate  => 'has_calendar_link',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:calendarLink',
    coerce     => 1,
);

has directory_server => (
    isa        => Str,
    is         => 'rw',
    predicate  => 'has_directory_server',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:directoryServer',
    is_element => 1,
);

has event => (
    isa        => ArrayRefOfContactEvent,
    is         => 'rw',
    predicate  => 'has_event',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:event',
    coerce     => 1,
);

has external_id => (
    isa        => ArrayRefOfExternalId,
    is         => 'rw',
    predicate  => 'has_external_id',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:excternalId',
    coerce     => 1,
);

has gender => (
    isa        => Gender,
    is         => 'rw',
    predicate  => 'has_gender',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:gender',
    coerce     => 1,
);

has group_membership => (
    isa        => ArrayRefOfGroupMembership,
    is         => 'rw',
    predicate  => 'has_group_membership',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:groupMembershipInfo',
    coerce     => 1,
);

has hobby => (
    isa        => ArrayRefOfHobby,
    is         => 'rw',
    predicate  => 'has_hobby',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:hobby',
    coerce     => 1,
);

has initials => (
    isa        => Str,
    is         => 'rw',
    predicate  => 'has_initials',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:initials',
    is_element => 1,
);

has jot => (
    isa        => ArrayRefOfJot,
    is         => 'rw',
    predicate  => 'has_jot',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:jot',
    coerce     => 1,
);

has language => (
    isa        => ArrayRefOfLanguage,
    is         => 'rw',
    predicate  => 'has_language',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:language',
    coerce     => 1,
);

has maiden_name => (
    isa        => Str,
    is         => 'rw',
    predicate  => 'has_maiden_name',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:maidenName',
    is_element => 1,
);

has mileage => (
    isa        => Str,
    is         => 'rw',
    predicate  => 'has_mileage',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:mileage',
    is_element => 1,
);

has nickname => (
    isa        => Str,
    is         => 'rw',
    predicate  => 'has_nickname',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:nickname',
    is_element => 1,
);

has occupation => (
    isa        => Str,
    is         => 'rw',
    predicate  => 'has_occupation',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:occupation',
    is_element => 1,
);

has priority => (
    isa        => Priority,
    is         => 'rw',
    predicate  => 'has_priority',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:priority',
    coerce     => 1,
);

has relation => (
    isa        => ArrayRefOfRelation,
    is         => 'rw',
    predicate  => 'has_relation',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:relation',
    coerce     => 1,
);

has sensitivity => (
    isa        => Sensitivity,
    is         => 'rw',
    predicate  => 'has_sensitivity',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:sensitivity',
    is_element => 1,
);

has shortname => (
    isa        => Str,
    is         => 'rw',
    predicate  => 'has_shortname',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:shortname',
    is_element => 1,
);

has subject => (
    isa        => Str,
    is         => 'rw',
    predicate  => 'has_subject',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:subject',
    is_element => 1,
);

has user_defined => (
    isa        => ArrayRefOfUserDefined,
    is         => 'rw',
    predicate  => 'has_user_defined',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:userDefinedField',
    coerce     => 1,
);

has website => (
    isa        => ArrayRefOfWebsite,
    is         => 'rw',
    predicate  => 'has_website',
    traits     => [ 'XmlField' ],
    xml_key    => 'gContact:website',
    coerce     => 1,
);

# Stolen from Meta/Attribute/Native/MethodProvider/Array.pm, need coercion
sub add_phone_number {
    my ($self,$phone) = @_;
    push @{ $self->phone_number }, to_PhoneNumber( $phone );
}
sub add_email {
    my ($self,$email) = @_;
    push @{ $self->email }, to_Email( $email );
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
