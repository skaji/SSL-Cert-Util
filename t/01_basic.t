use strict;
use warnings;
use utf8;
use Test::More;
use SSL::Cert::Util qw(get_cert);
use Data::Dumper;

plan skip_all => 'Set $ENV{FORCE_TEST} to run this test, which will connect google.com'
    unless $ENV{FORCE_TEST};

my $cert = get_cert("google.com");
ok !$cert->{error};
ok $cert->{not_after};
ok $cert->{not_before};

my $fail = get_cert("hogehoge", timeout => 2);
is $fail->{error}, "timeout";

done_testing;
