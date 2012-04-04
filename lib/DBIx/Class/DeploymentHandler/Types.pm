package DBIx::Class::DeploymentHandler::Types;
use strict;
use warnings;

# ABSTRACT: Types internal to DBIx::Class::DeploymentHandler

use Sub::Quote 'quote_sub';

use Sub::Exporter -setup => {
  exports => [ qw(Storage ResultSet StrSchemaVersion) ],
};

sub ResultSet {
quote_sub(q{
     use Check::ISA;
     obj($_[0], 'DBIx::Class::ResultSet')
        or die 'version_rs should be a DBIx::Class::ResultSet!'
  })
}

sub Storage {
quote_sub(q{
     use Check::ISA;
     obj($_[0], 'DBIx::Class::Storage')
        or die 'storage should be a DBIx::Class::Storage!'
  })
}

sub StrSchemaVersion {
  quote_sub(q{
    die(defined $_[0]
      ? "Schema version (currently '$_[0]') must be a string"
      : 'Schema version must be defined'
    ) unless ref(\$_[0]) eq 'SCALAR'
  })
}

1;

# vim: ts=2 sw=2 expandtab

__END__

