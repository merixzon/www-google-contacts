package WWW::Google::Contacts;

# ABSTRACT: Google Contacts Data API

use Moose;

use Carp qw/croak/;

use WWW::Google::Contacts::Server;
use WWW::Google::Contacts::Contact;
use WWW::Google::Contacts::ContactList;
use WWW::Google::Contacts::Group;
use WWW::Google::Contacts::GroupList;

our $VERSION = '0.05';
$VERSION = eval $VERSION;

has username => (
    isa        => 'Str',
    is         => 'rw',
);

has password => (
    isa        => 'Str',
    is         => 'rw',
);

has server => (
    is         => 'ro',
    lazy_build => 1,
);

# backward compability
has email => ( isa => 'Str', is => 'rw', trigger => sub { $_[0]->username( $_[1] ) } );
has pass  => ( isa => 'Str', is => 'rw', trigger => sub { $_[0]->password( $_[1] ) } );

sub _build_server {
    my $self = shift;
    my $args = {};
    foreach my $a (qw( username password )) {
        $args->{ $a } = $self->$a if $self->$a;
    }
    return WWW::Google::Contacts::Server->initialize( $args );
}

sub new_contact {
    my $self = shift;
    return WWW::Google::Contacts::Contact->new( server => $self->server, @_ );
}

sub contact {
    my ($self,$id) = @_;
    return WWW::Google::Contacts::Contact->new( server => $self->server, id => $id)->retrieve;
}

sub contacts {
    my $self = shift;

    my $list = WWW::Google::Contacts::ContactList->new( server => $self->server );
    return $list;
}

sub new_group {
    my $self = shift;
    return WWW::Google::Contacts::Group->new( server => $self->server, @_ );
}

sub group {
    my ($self,$id) = @_;
    return WWW::Google::Contacts::Group->new( server => $self->server, id => $id)->retrieve;
}

sub groups {
    my $self = shift;

    my $list = WWW::Google::Contacts::GroupList->new( server => $self->server );
    return $list;
}

# All code below is for backwards compability

sub login {
    my ($self, $email, $pass) = @_;
    $self->email( $email );
    $self->pass( $pass );
    $self->server->authenticate;
    return 1;
}

sub create_contact {
    my $self = shift;
    my $data = scalar @_ % 2 ? shift : { @_ };

    my $contact = $self->new_contact;
    return $self->_create_or_update_contact( $contact, $data );
}

sub _create_or_update_contact {
    my ($self, $contact, $data) = @_;

    $contact->given_name( $data->{ givenName } );
    $contact->family_name( $data->{ familyName } );
    $contact->notes( $data->{Notes} );
    $contact->email({
        type => "work",
        primary => 1,
        value => $data->{ primaryMail },
        display_name => $data->{ displayName },
    });
    if ( $contact->{secondaryMail} ) {
        $contact->add_email({
            type => "home",
            value => $data->{ secondaryMail },
        });
    }
#    if ( $contact->{groupMembershipInfo} ) {
#        $data->{'atom:entry'}->{'gContact:groupMembershipInfo'} = {
#            deleted => 'false',
#            href => $contact->{groupMembershipInfo}
#        };
#    }
    if ( $contact->create_or_update ) {
        return 1;
    }
    return 0;
}

sub get_contacts {
    my $self = shift;

    my $list = $self->contacts;
    my @contacts;
    foreach my $c ( @{ $list->elements } ) {
        my $d = $c;
        $d->{name} = $d->{'gd:name'};
        $d->{email} = $d->{'gd:email'};
        $d->{groupMembershipInfo} = $d->{'gContact:groupMembershipInfo'};
        push @contacts, $d;
    }
    return @contacts;
}

sub get_contact {
    my ($self, $id) = @_;

    my $contact = $self->new_contact( id => $id )->retrieve;
    my $data = $contact->raw_data_for_backwards_compability;
    $data->{name} = $data->{'gd:name'};
    $data->{email} = $data->{'gd:email'};
    $data->{groupMembershipInfo} = $data->{'gContact:groupMembershipInfo'};
    return $data;
}

sub update_contact {
    my ($self, $id, $contact) = @_;

    my $c = $self->new_contact( id => $id )->retrieve;
    return $self->_create_or_update_contact( $c, $contact );
}

sub delete_contact {
    my ($self, $id) = @_;

    $self->new_contact( id => $id )->delete;
}

sub get_groups {
    my $self = shift;

    my $list = $self->groups;
    my @groups;
    foreach my $d ( @{ $list->elements } ) {
        push @groups, {
            id => $d->{id},
            title   => $d->{title},
            updated => $d->{updated},
            exists $d->{'gContact:systemGroup'} ? ('gContact:systemGroup' => $d->{'gContact:systemGroup'}->{'id'}) : (),
        }
    }
    return @groups;
}

sub get_group {
    my ($self, $id) = @_;

    my $group = $self->new_group( id => $id )->retrieve;
    my $data = $group->raw_data_for_backwards_compability;
    return $data;
}

sub _create_or_update_group {
    my ($self, $group, $data) = @_;

    $group->title( $data->{ title } );
    if ( $group->create_or_update ) {
        return 1;
    }
    return 0;
}

sub create_group {
    my $self = shift;
    my $data = scalar @_ % 2 ? shift : { @_ };

    my $group = $self->new_group;
    return $self->_create_or_update_group( $group, $data );
}

sub update_group {
    my ($self, $id, $args) = @_;

    my $g = $self->new_group( id => $id )->retrieve;
    return $self->_create_or_update_group( $g, $args );
}

sub delete_group {
    my ($self, $id) = @_;

    $self->new_group( id => $id )->delete;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 SYNOPSIS

    use WWW::Google::Contacts;

    my $google = WWW::Google::Contacts->new( username => "your.username", password => "your.password" );

    my $contact = $google->new_contact;
    $contact->full_name("Emmett Brown");
    $contact->name_prefix("Dr");
    $contact->email('doctor@timetravel.org');
    $contact->hobby("Time travel");
    $contact->jot([ "Went back in time", "Went forward in time", "Became blacksmith" ]),
    $contact->create;

    my @contacts = $google->contacts->search({ given_name => "Emmett" });
    foreach my $c ( @contacts ) {
        print "Got the following jots about the good doctor\n";
        foreach my $jot ( @{ $c->jot } ) {
            print "Jot: " . $jot->value . "\n";
        }
        print "And now he goes back to the future\n";
        $c->delete;
    }


    my $groups = $google->groups;
    while ( my $group = $groups->next ) {
        print "Title = " . $group->title . "\n";
    }

=head1 DESCRIPTION

This module implements 'Google Contacts Data API' according L<http://code.google.com/apis/contacts/docs/3.0/developers_guide_protocol.html>

=head1 CONSTRUCTOR

=head2 new( username => .., password => .. )

I<username> and I<password> are required arguments and must be valid Google credentials. If you do not have a Google account
you can create one at L<https://www.google.com/accounts/NewAccount>.

=head1 METHODS

=head2 $google->new_contact

Returns a new empty L<WWW::Google::Contacts::Contact> object.

=head2 $google->contact( $id )

Given a valid contact ID, returns a L<WWW::Google::Contacts::Contact> object populated with contact data from Google.

=head2 $google->contacts

Returns a L<WWW::Google::Contacts::ContactList> object which can be used to iterate over all your contacts.

=head2 $google->new_group

Returns a new L<WWW::Google::Contacts::Group> object.

=head2 $google->group( $id )

Given a valid group ID, returns a L<WWW::Google::Contacts::Group> object populated with group data from Google.

=head2 $google->groups

Returns a L<WWW::Google::Contacts::GroupList> object which can be used to iterate over all your groups.

=head1 DEPRECATED METHODS

The old module interface is still available, but its use is discouraged. It will eventually be removed from the module.

=over 4

=item * new/login

    my $gcontacts = WWW::Google::Contacts->new();
    $gcontacts->login('fayland@gmail.com', 'pass') or die 'login failed';

=item * create_contact

    $gcontacts->create_contact( {
        givenName => 'FayTestG',
        familyName => 'FayTestF',
        fullName   => 'Fayland Lam',
        Notes     => 'just a note',
        primaryMail => 'primary@example.com',
        displayName => 'FayTest Dis',
        secondaryMail => 'secndary@test.com', # optional
    } );

return 1 if created

=item * get_contacts

    my @contacts = $gcontacts->get_contacts;
    my @contacts = $gcontacts->get_contacts( {
        group => 'thin', # default to 'full'
    } )
    my @contacts = $gcontacts->get_contacts( {
        updated-min => '2007-03-16T00:00:00',
        start-index => 10,
        max-results => 99, # default as 9999
    } );

get contacts from this account.

C<group> refers L<http://code.google.com/apis/contacts/docs/2.0/reference.html#Projections>

C<start-index>, C<max_results> etc refer L<http://code.google.com/apis/contacts/docs/2.0/reference.html#Parameters>

=item * get_contact($id)

    my $contact = $gcontacts->get_contact('http://www.google.com/m8/feeds/contacts/account%40gmail.com/base/1');

get a contact by B<id>

=item * update_contact

    my $status = $gcontacts->update_contact('http://www.google.com/m8/feeds/contacts/account%40gmail.com/base/123623e48cb4e70a', {
        givenName => 'FayTestG2',
        familyName => 'FayTestF2',
        fullName   => 'Fayland Lam2',
        Notes     => 'just a note2',
        primaryMail => 'primary@example2.com',
        displayName => 'FayTest2 Dis',
        secondaryMail => 'secndary@test62.com', # optional
    } );

update a contact

=item * delete_contact($id)

    my $status = $gcontacts->delete_contact('http://www.google.com/m8/feeds/contacts/account%40gmail.com/base/1');

The B<id> is from C<get_contacts>.

=item * create_group

    my $status = $gcontacts->create_group( { title => 'Test Group' } );

Create a new group

=item * get_groups

    my @groups = $gcontacts->get_groups;
    my @groups = $gcontacts->get_groups( {
        updated-min => '2007-03-16T00:00:00',
        start-index => 10,
        max-results => 99, # default as 9999
    } );

Get all groups.

=item * get_group($id)

    my $group = $gcontacts->get_group('http://www.google.com/m8/feeds/groups/account%40gmail.com/base/6e744e7d0a4b398c');

get a group by B<id>

=item * update_group($id, { title => $title })

    my $status = $gcontacts->update_group( 'http://www.google.com/m8/feeds/groups/account%40gmail.com/base/6e744e7d0a4b398c', { title => 'New Test Group 66' } );

Update a group

=item * delete_group

    my $status = $gcontacts->delete_contact('http://www.google.com/m8/feeds/groups/account%40gmail.com/base/6e744e7d0a4b398c');

=back

=head1 SEE ALSO

L<WWW::Google::Contacts::Contact>

L<WWW::Google::Contacts::ContactList>

L<WWW::Google::Contacts::Group>

L<WWW::Google::Contacts::GroupList>

L<http://code.google.com/apis/contacts/docs/3.0/developers_guide_protocol.html>

=head1 ACKNOWLEDGEMENTS

John Clyde - who share me with his code about Contacts API

=head1 AUTHOR

  Fayland Lam <fayland@gmail.com>
  Magnus Erixzon <magnus@erixzon.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Fayland Lam.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut
