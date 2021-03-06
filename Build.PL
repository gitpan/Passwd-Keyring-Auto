use strict;
use warnings;
use Module::Build;

# Recommendations are OS-dependant
my %recommends;
if($^O eq 'darwin') {
    $recommends{'Passwd::Keyring::OSXKeychain'} = '0.10';
}
if($^O =~ /^MSWin/) {
    # TODO: windows keyrings
}

if($^O !~ /^(MSWin|dos|darwin)/) {
    $recommends{'Passwd::Keyring::Gnome'} = '0.25';
    $recommends{'Passwd::Keyring::KDEWallet'} = '0.20';
}

my $builder = Module::Build->new(
    module_name         => 'Passwd::Keyring::Auto',
    license             => 'perl',
    dynamic_config      => 1,

    requires            => {
        'Passwd::Keyring::Memory' => '0.24',
        'perl' => '5.6.0',   # let's believe perlver
    },
    build_requires => {
        'Test::More' => 0,
        'Passwd::Keyring::Memory' => '0.24',
        'Pod::Readme' => 0,
    },
    configure_requires => {
        'Module::Build' => '0.36',
    },
    recommends => \%recommends,

    share_dir => {
        dist => [ 'example' ],
    },

    create_makefile_pl => 'traditional',
    add_to_cleanup      => [ 'Passwd-Keyring-Auto-*' ],

    create_readme      => 1,
    dist_author         => q{Marcin Kasperski <Marcin.Kasperski@mekk.waw.pl>},
    dist_version_from   => 'lib/Passwd/Keyring/Auto.pm',
    meta_merge => {
        keywords => [ qw/ passwords security secure-storage keyring / ],
        resources => {
            license     => ['http://dev.perl.org/licenses/'],
            homepage    => 'http://bitbucket.org/Mekk/perl-keyring-auto',
            repository => 'http://bitbucket.org/Mekk/perl-keyring-auto',
            bugtracker => 'https://bitbucket.org/Mekk/perl-keyring-auto/issues',
        },
    },
    # distmeta  => 1,
);

$builder->create_build_script();
