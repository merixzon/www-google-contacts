package WWW::Google::Contacts::ContactList;

use Moose;
use WWW::Google::Contacts::Contact;

extends 'WWW::Google::Contacts::Base';

with 'WWW::Google::Contacts::Roles::List';

sub baseurl { 'http://www.google.com/m8/feeds/contacts/default' }
sub element_class { 'WWW::Google::Contacts::Contact' }

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
