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

=head1 SYNOPSIS

    use WWW::Google::Contacts;

    my $google = WWW::Google::Contacts->new( username => "your.username", password => "your.password" );

    my $group = $google->new_group;
    $group->title("Lovers");

=head1 METHODS

=head2 $group->create

Writes the group to your Google account.

=head2 $group->retrieve

Fetches group details from Google account.

=head2 $group->update

Updates existing group in your Google account.

=head2 $group->delete

Deletes group from your Google account.

=head2 $group->create_or_update

Creates or updates group, depending on if it already exists

=head1 ATTRIBUTES

All these attributes are gettable and settable on Group objects.

=over 4

=item title

The title of the group

 $group->title("People I'm only 'friends' with because of the damn Facebook");

=back

=head1 AUTHOR

 Magnus Erixzon <magnus@erixzon.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Magnus Erixzon / Fayland Lam.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut
