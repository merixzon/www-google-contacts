package WWW::Google::Contacts::Type::Base;

use Moose;

extends 'WWW::Google::Contacts::Base';

sub search_field {
    return undef;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
