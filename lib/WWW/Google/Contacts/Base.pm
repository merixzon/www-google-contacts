package WWW::Google::Contacts::Base;

use Moose;
use Scalar::Util qw( blessed );

sub _xml_attributes {
    my $self = shift;
    return grep { $_->does( 'XmlField' ) }
        $self->meta->get_all_attributes;
}

sub to_xml_hashref {
    my $self = shift;

    my $to_return = {};
    foreach my $attr ( $self->_xml_attributes ) {
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

    foreach my $attr ( $self->_xml_attributes ) {
        if ( defined $data->{ $attr->xml_key } ) {
            my $name = $attr->name;
            $self->$name( $data->{ $attr->xml_key } );
        }
    }
}

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;

    if ( @_ > 1 ) {
        return $class->$orig( @_ );
    }

    # if we have a ref, let's see if we need to mangle xml fields
    my $data = shift @_;
    foreach my $attr ( $class->_xml_attributes ) {
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