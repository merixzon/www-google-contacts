package WWW::Google::Contacts::Roles::HasTypeAndLabel;

use MooseX::Role::Parameterized;
use MooseX::Types::Moose qw( ArrayRef Str );
use WWW::Google::Contacts::InternalTypes qw( Rel );
use Perl6::Junction qw( any );

parameter valid_types => (
    isa      => ArrayRef,
    required => 1,
);

parameter default_type => (
    isa      => Str,
    required => 1,
);

role {
    my $param = shift;
    my $valid_types = $param->valid_types;
    my $default_type = $param->default_type;

    has type => (
        isa       => Rel,
        is        => 'rw',
        traits    => [ 'XmlField' ],
        xml_key   => 'rel',
        predicate => 'has_type',
        trigger   => \&_type_set,
        include_in_xml => sub { return $_[0]->has_valid_type },
        default   => sub { to_Rel( $default_type ) },
        coerce    => 1,
    );

    has label => (
        isa      => Str,
        is       => 'rw',
        traits    => [ 'XmlField' ],
        xml_key   => 'label',
        trigger   => \&_label_set,
        predicate => 'has_label',
        include_in_xml => sub { return ! $_[0]->has_valid_type },
        default   => sub { $default_type },
    );

    method has_valid_type => sub {
        my $self = shift;
        return any(@{ $valid_types }) eq $self->type->name ? 1 : 0;
    };
};

# To make sure type and label are always up to date with eachother

sub _type_set {
    my ($self, $type) = @_;
    return if ( defined $self->label and $self->label eq $type->name );
    $self->label( $type->name );
};

sub _label_set {
    my ($self, $label) = @_;
    return if ( defined $self->type and $self->type->name eq $label );
    $self->type( $label );
};

no Moose::Role;
