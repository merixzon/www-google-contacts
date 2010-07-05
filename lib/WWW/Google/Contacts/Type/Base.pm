package WWW::Google::Contacts::Type::Base;

use Moose;

extends 'WWW::Google::Contacts::Base';

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
