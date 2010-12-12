#!/usr/bin/env perl
use strict;
use warnings;

## NOTE -- This test relies on you having specific data in your google account
# One group called "Test group", with at least one member

use WWW::Google::Contacts;
use Test::More;
use Data::Dumper;

my $username = $ENV{TEST_GOOGLE_USERNAME};
my $password = $ENV{TEST_GOOGLE_PASSWORD};

plan skip_all => 'no TEST_GOOGLE_USERNAME or TEST_GOOGLE_PASSWORD set in the environment'
    unless $username and $password;

my $google = WWW::Google::Contacts->new(username => $username, password => $password);
isa_ok($google, 'WWW::Google::Contacts');

my @groups = $google->groups->search({ title => "Test group" });
foreach my $g ( @groups ) {
    is ( scalar @{ $g->member } > 0, 1, "Test group got members");
    my $member = $g->member->[0];

    $member->postal_address({
        street   => "Somestreet " . int(rand(100)),
        city     => "London",
        postcode => '',
    });

    $member->update;

    # Now fetch this user again and ensure data is valid
    my $update = $google->contact( $member->id );
    my $addr = $update->postal_address->[0];
    ok ( defined $addr, "Updated user got postal address");
    is ( $addr->city, "London", "...correct city");
    is ( $addr->type->name, "home", "...got the default type");
}

done_testing;
