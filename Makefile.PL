use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker 6.17;

my %WriteMakefileArgs = (
  "ABSTRACT" => "OpenCloset::Size::Guess driver for the BodyKit service",
  "AUTHOR" => "\x{d64d}\x{d615}\x{c11d} - Hyungsuk Hong <aanoaa\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.17"
  },
  "DISTNAME" => "OpenCloset-Size-Guess-BodyKit",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.008",
  "NAME" => "OpenCloset::Size::Guess::BodyKit",
  "PREREQ_PM" => {
    "HTTP::Tiny" => "0.056",
    "IO::Socket::SSL" => 0,
    "JSON" => 0,
    "Moo" => 0,
    "Mozilla::CA" => 0,
    "Net::SSLeay" => 0,
    "OpenCloset::Size::Guess" => "0.003",
    "OpenCloset::Size::Guess::Role::Base" => 0,
    "Try::Tiny" => 0,
    "Types::Standard" => 0,
    "utf8" => 0
  },
  "TEST_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "File::Spec" => 0,
    "Test::More" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.001",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "ExtUtils::MakeMaker" => "6.17",
  "File::Spec" => 0,
  "HTTP::Tiny" => "0.056",
  "IO::Socket::SSL" => 0,
  "JSON" => 0,
  "Moo" => 0,
  "Mozilla::CA" => 0,
  "Net::SSLeay" => 0,
  "OpenCloset::Size::Guess" => "0.003",
  "OpenCloset::Size::Guess::Role::Base" => 0,
  "Test::More" => 0,
  "Try::Tiny" => 0,
  "Types::Standard" => 0,
  "strict" => 0,
  "utf8" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
