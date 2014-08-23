package SSL::Cert::Util;
use 5.008005;
use strict;
use warnings;
use Net::SSLeay qw(sslcat);
use IO::Socket::SSL::Utils 'CERT_asHash';
use Sys::SigAction qw(timeout_call);

our $VERSION = "0.01";

use Exporter 'import';
our @EXPORT_OK = qw(get_cert);

sub get_cert {
    my $host = shift;
    my %opt  = ref $_[0] ? %{$_[0]} : @_;
    my $port = $opt{port} || 443;
    my $message = $opt{message};
    my $digest_name = $opt{digest_name} || 'sha256';
    my $timeout = $opt{timeout};

    my ($reply, $error, $cert);
    my $is_timeout = 0;
    if ($timeout) {
        $is_timeout = timeout_call $timeout, sub {
            ($reply, $error, $cert) = sslcat $host, $port, $message ? $message : ();
        };
    } else {
        ($reply, $error, $cert) = sslcat $host, $port, $message ? $message : ();
    }

    if ($cert) {
        return CERT_asHash($cert, $digest_name);
    } else {
        if ($is_timeout) {
            return { error => "timeout" };
        } else {
            chomp $error;
            return { error => $error };
        }
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

SSL::Cert::Util - SSL cert util

=head1 SYNOPSIS

    use SSL::Cert::Util qw(get_cert);

    my $cert = get_cert "google.com", timeout => 10;

    if (my $error = $cert->{error}) {
        die $error;
    } else {
        my $not_before = $cert->{not_before}; #=> 1406688135
        my $not_after  = $cert->{not_after};  #=> 1414422000
    }


=head1 INSTALL

    > cpanm git://github.com/shoichikaji/SSL-Cert-Util.git

=head1 DESCRIPTION

SSL::Cert::Util provides C< get_cert() > function.

=head1 FUNCTIONS

=head2 C< $cert = get_cert($host, %option) >

Returns the information of the certificate as Perl hash reference.
If failed, it returns C<< +{ error => $error } >>.

You may specify the following C< %option >:

=over 4

=item port

Port number. default: 443

=item timeout

Connect timeout second. default: undef, i.e. never timeout

=item digest_name

Digest algorism name, which is used to extract the information from certificate.
default: sha256

=item message

Message to be sent to ssl server.

=back

=head1 LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@cpan.orgE<gt>

=cut

