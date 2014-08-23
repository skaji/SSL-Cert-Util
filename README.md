# NAME

SSL::Cert::Util - SSL cert util

# SYNOPSIS

    use SSL::Cert::Util qw(get_cert);

    my $cert = get_cert "google.com", timeout => 10;

    if (my $error = $cert->{error}) {
        die $error;
    } else {
        my $not_before = $cert->{not_before}; #=> 1406688135
        my $not_after  = $cert->{not_after};  #=> 1414422000
    }

# INSTALL

    > cpanm git://github.com/shoichikaji/SSL-Cert-Util.git

# DESCRIPTION

SSL::Cert::Util provides ` get_cert() ` function.

# FUNCTIONS

## ` $cert = get_cert($host, %option) `

Returns the information of the certificate as Perl hash reference.
If failed, it returns `+{ error => $error }`.

You may specify the following ` %option `:

- port

    Port number. default: 443

- timeout

    Connect timeout second. default: undef, i.e. never timeout

- digest\_name

    Digest algorism name, which is used to extract the information from certificate.
    default: sha256

- message

    Message to be sent to ssl server.

# LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shoichi Kaji <skaji@cpan.org>
