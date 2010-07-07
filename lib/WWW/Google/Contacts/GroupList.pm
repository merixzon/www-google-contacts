package WWW::Google::Contacts::GroupList;

use Moose;
use WWW::Google::Contacts::Group;

extends 'WWW::Google::Contacts::Base';

with 'WWW::Google::Contacts::Roles::List';

sub baseurl { 'http://www.google.com/m8/feeds/groups/default' }
sub element_class { 'WWW::Google::Contacts::Group' }

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
