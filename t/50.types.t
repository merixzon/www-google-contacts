#!perl

use strict;
use warnings;
use Data::Dumper;
use Try::Tiny;
use Test::More tests => 15;

use WWW::Google::Contacts::Types qw( PhoneNumber ArrayRefOfPhoneNumber );

# phone_number
my $phone_number;
my $num = "+123456";
$phone_number = to_PhoneNumber( $num );
ok( defined $phone_number, "Valid phone number type" );
is( $phone_number->value, $num, "...right value");
is( $phone_number->type->name, "mobile", "...got default type [mobile]");

$phone_number = to_PhoneNumber({ type => "mobile", value => $num });
ok( defined $phone_number, "Valid phone number type" );
is( $phone_number->value, $num, "...right value");
is( $phone_number->type->name, "mobile", "...got explicitly set type [mobile]");

my $res = to_ArrayRefOfPhoneNumber( $num );
is( ref $res, "ARRAY", "Got an array of phone numbers");
$phone_number = shift @{ $res };
ok( defined $phone_number, "Valid phone number type" );
is( $phone_number->value, $num, "...right value");
is( $phone_number->type->name, "mobile", "...got default type [mobile]");

$res = to_ArrayRefOfPhoneNumber([ 1,2,3 ]);
ok( defined $res, "Got array ref");
is( scalar @{ $res }, 3, "...with 3 entries");
is( $res->[0]->value, "1", "Entry 1 is correct");
is( $res->[1]->value, "2", "Entry 2 is correct");
is( $res->[2]->value, "3", "Entry 3 is correct");
