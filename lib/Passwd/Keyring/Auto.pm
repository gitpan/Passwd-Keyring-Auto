package Passwd::Keyring::Auto;

use warnings;
use strict;
use base 'Exporter';
our @EXPORT_OK = qw(get_keyring);

=head1 NAME

Passwd::Keyring::Auto - interface to secure password storage(s)

=head1 VERSION

Version 0.21

=cut

our $VERSION = '0.21';

=head1 SYNOPSIS

Passwd::Keyring is about securely preserving passwords and similar
sensitive data applications use in backends like Gnome Keyring, KDE
Wallet, OSX/Keychain etc.

While modules like Passwd::Keyring::Gnome handle specific backends,
Passwd::Keyring::Auto tries to pick the best backend available,
considering the current desktop environment.

    use Passwd::Keyring::Auto qw(get_keyring);

    my $keyring = get_keyring();

    my $username = "someuser";
    my $password = $keyring->get_password($username, "some-app");
    if(! $password) {
        # ... somehow interactively prompt for password
        $keyring->set_password($username, $password, "some-app");
    }
    login_somewhere_using($username, $password);
    if( password_was_wrong ) {
        $keyring->clear_password($username, "some-app");
    }

If any secure backend is available, password is preserved
for successive runs, and users need not be prompted.

Instead of auto-detection, one can also be explicit:

    use Passwd::Keyring::Gnome;
    my $keyring = Passwd::Keyring::Gnome->new();
    # ... and so on

=head1 EXPORT

get_keyring

=head1 SUBROUTINES/METHODS

=head2 get_keyring

Returns the keyring object most appropriate for the
current system.

=cut

sub get_keyring {
    # FIXME: really detect and prioritize

    my $keyring;
    if( $ENV{GNOME_KEYRING_CONTROL} ) {
        eval {
            require Passwd::Keyring::Gnome;
            $keyring = Passwd::Keyring::Gnome->new();
        };
        return $keyring if $keyring;
    }

    # Last resort
    require Passwd::Keyring::Memory;
    return Passwd::Keyring::Memory->new();
}

=head1 AUTHOR

Marcin Kasperski, C<< <Marcin.Kasperski at mekk.waw.pl> >>

=head1 BUGS

Please report any bugs or feature requests to 
issue tracker at L<https://bitbucket.org/Mekk/perl-keyring>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Passwd::Keyring::Auto

Source code is published and issues are tracked at:

    L<https://bitbucket.org/Mekk/perl-keyring-auto>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Marcin Kasperski.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Keyring