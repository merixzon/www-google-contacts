package WWW::Google::Contacts::Base;

use Moose;
use Scalar::Util qw( blessed );

sub xml_attributes {
    my $self = shift;
    return grep { $_->does( 'XmlField' ) }
        $self->meta->get_all_attributes;
}

sub get_xml_key {
    my ($self, $field) = @_;

    foreach my $attr ( $self->xml_attributes ) {
        my $name = $attr->name;
        my $val = $self->$name;
        if ( $name eq $field ) {
            return $attr->xml_key;
        }
        elsif ( blessed($val) and $val->can("to_xml_hashref") ) {
            my $recurse = $val->get_xml_key( $field );
            if ( $recurse ) {
                my $parent = $attr->xml_key;
                return { $parent => $recurse };
            }
        }
    }
    return undef;
}

sub to_xml_hashref {
    my $self = shift;

    my $to_return = {};
    foreach my $attr ( $self->xml_attributes ) {
        my $predicate = $attr->predicate;

        next if defined $predicate
            and not $self->$predicate
            and not $attr->is_lazy;

        my $name = $attr->name;
        my $val = $self->$name;

        $to_return->{ $attr->xml_key } =
            ( blessed($val) and $val->can("to_xml_hashref") ) ? $val->to_xml_hashref
            : ( ref($val) and ref($val) eq 'ARRAY' ) ? [ map { $_->to_xml_hashref } @{ $val } ]
            : $attr->has_to_xml ? do { my $code = $attr->to_xml ; &$code( $val ) }
            : $attr->is_element ? [ $val ]
            : $val;
    }
    return $to_return;
}

sub set_from_server {
    my ($self, $data) = @_;

    foreach my $attr ( $self->xml_attributes ) {
        if ( defined $data->{ $attr->xml_key } ) {
            my $name = $attr->name;
            $self->$name( $data->{ $attr->xml_key } );
        }
    }
    return $self;
}

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;

    return $class->$orig() unless ( @_ );

    # let's see if we need to mangle xml fields
    my $data;
    if ( @_ > 1 ) {
        $data = {@_};
    }
    else {
        $data = shift @_;
    }

    foreach my $attr ( $class->xml_attributes ) {
        if ( defined $data->{ $attr->xml_key } ) {
            $data->{ $attr->name } = delete $data->{ $attr->xml_key };
        }
    }
    return $class->$orig( $data );
};

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
