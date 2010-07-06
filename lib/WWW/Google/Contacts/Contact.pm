package WWW::Google::Contacts::Contact;

use Moose;
use MooseX::Types::Moose qw( Str );
use WWW::Google::Contacts::Types qw(
                                       Category
                                       Content
                                       Name
                                       ArrayRefOfPhoneNumber PhoneNumber
                                       ArrayRefOfIM
                                       ArrayRefOfEmail Email
                                       ArrayRefOfOrganization Organization
                                       ArrayRefOfPostalAddress PostalAddress
                               );
use WWW::Google::Contacts::Meta::Attribute::Trait;
use WWW::Google::Contacts::Server;
use Carp qw( croak );
use XML::Simple ();

extends 'WWW::Google::Contacts::Base';

has id => (
    isa       => Str,
    is        => 'ro',
    writer    => '_set_id',
);

has category => (
    isa       => Category,
    is        => 'rw',
    predicate => 'has_category',
    traits    => [ 'XmlField' ],
    xml_key   => 'category',
    default   => sub { undef },
    is        => 'rw',
    coerce    => 1,
);

has content => (
    isa       => Content,
    is        => 'rw',
    predicate => 'has_content',
    traits    => [ 'XmlField' ],
    xml_key   => 'content',
    coerce    => 1,
);

has name => (
    isa       => Name,
    is        => 'rw',
    predicate => 'has_name',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:name',
    handles   => [qw( given_name additional_name family_name
                      name_prefix name_suffix full_name )],
    default   => sub { undef }, # empty Name object, so handles will work
    coerce    => 1,
);

has phone_number => (
    isa       => ArrayRefOfPhoneNumber,
    is        => 'rw',
    predicate => 'has_phone_number',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:phoneNumber',
    is        => 'rw',
    coerce    => 1,
);

has email => (
    isa       => ArrayRefOfEmail,
    is        => 'rw',
    predicate => 'has_email',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:email',
    is        => 'rw',
    coerce    => 1,
);

has im => (
    isa       => ArrayRefOfIM,
    is        => 'rw',
    predicate => 'has_im',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:im',
    is        => 'rw',
    coerce    => 1,
);

has organization => (
    isa       => ArrayRefOfOrganization,
    is        => 'rw',
    predicate => 'has_organization',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:organization',
    is        => 'rw',
    coerce    => 1,
);

has postal_address => (
    isa       => ArrayRefOfPostalAddress,
    is        => 'rw',
    predicate => 'has_postal_address',
    traits    => [ 'XmlField' ],
    xml_key   => 'gd:structuredPostalAddress',
    is        => 'rw',
    coerce    => 1,
);

has server => (
    is        => 'ro',
    default   => sub { WWW::Google::Contacts::Server->instance },
);

# Stolen from Meta/Attribute/Native/MethodProvider/Array.pm, need coercion
sub add_phone_number {
    my ($self,$phone) = @_;
    push @{ $self->phone_number }, to_PhoneNumber( $phone );
}

sub d {
    my $self = shift;
    use Data::Dumper;
    print Dumper { d => $self->to_xml_hashref };
}


sub create {
    my $self = shift;

    my $entry = {
        entry => {
            'xmlns' => 'http://www.w3.org/2005/Atom',
            'xmlns:gd' => 'http://schemas.google.com/g/2005',
            %{ $self->to_xml_hashref },
        },
    };
    my $xmls = XML::Simple->new;
    my $xml = $xmls->XMLout( $entry, KeepRoot => 1 );
    my $url = 'http://www.google.com/m8/feeds/contacts/default/full';
    my $res = $self->server->post( $url, $xml );
    my $data = $xmls->XMLin($res->content, SuppressEmpty => undef);
    return $self->set_from_server( $data );
}

sub retrieve {
    my $self = shift;
    croak "No id set" unless $self->id;

    my $res = $self->server->get( $self->id );
    my $xmls = XML::Simple->new;
    my $data = $xmls->XMLin($res->content, SuppressEmpty => undef);
    return $self->set_from_server( $data );
}

sub update {
    my $self = shift;
    croak "No id set" unless $self->id;

    my $entry = {
        entry => {
            'xmlns' => 'http://www.w3.org/2005/Atom',
            'xmlns:gd' => 'http://schemas.google.com/g/2005',
            %{ $self->to_xml_hashref },
        },
    };
    my $xmls = XML::Simple->new;
    my $xml = $xmls->XMLout( $entry, KeepRoot => 1 );
    my $res = $self->server->put( $self->id, $xml );
}

sub delete {
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
