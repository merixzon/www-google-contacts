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
    foreach my $member ( @{ $g->member } ) {
        is ( defined $member->full_name, 1, "Member got full name [" . $member->full_name . "]" );

        my $email = $member->email->[0];
        ok ( defined $email, "...got an email address");
        my $type = $email->type;
        print "Type = $type\n";
    }
}

done_testing;
