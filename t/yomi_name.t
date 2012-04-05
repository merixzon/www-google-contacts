#!/usr/bin/env perl
use strict;
use warnings;

use WWW::Google::Contacts::Types qw( Name );
use Test::More;

my $name = {
    full_name => "Foo bar",
    family_name => {
        content => "bar",
        yomi => '',
    },
    given_name => {
        content => 'Foo',
        yomi => '',
    },
};

my $res = to_Name( $name );
is $res->family_name, 'bar';
is $res->given_name, 'Foo';

done_testing;
