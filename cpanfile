requires 'perl', '5.008005';
requires 'IO::Socket::SSL';
requires 'Net::SSLeay';
requires 'Sys::SigAction';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

