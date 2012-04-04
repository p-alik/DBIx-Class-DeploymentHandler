package DBIx::Class::DeploymentHandler::VersionHandler::DatabaseToSchemaVersions;
use Moo;
use Sub::Quote 'quote_sub';
use MooX::Types::MooseLike::Base qw(Str Bool);

# ABSTRACT: Go straight from Database to Schema version

with 'DBIx::Class::DeploymentHandler::HandlesVersioning';

has schema_version => (
  isa      => Str,
  is       => 'ro',
  required => 1,
);

has database_version => (
  isa      => Str,
  is       => 'ro',
  required => 1,
);

has to_version => ( # configuration
  is   => 'ro',
  isa  => Str,
  builder => '_build_to_version',
);

sub _build_to_version { $_[0]->schema_version }

has once => (
  is      => 'rw',
  isa     => Bool,
  default => quote_sub(q{undef}),
);

sub next_version_set {
  my $self = shift;
  return undef
    if $self->once;

  $self->once(!$self->once);
  return undef
    if $self->database_version eq $self->to_version;
  return [$self->database_version, $self->to_version];
}

sub previous_version_set {
  my $self = shift;
  return undef
    if $self->once;

  $self->once(!$self->once);
  return undef
    if $self->database_version eq $self->to_version;
  return [$self->database_version, $self->to_version];
}

1;

# vim: ts=2 sw=2 expandtab

__END__

=head1 SEE ALSO

This class is an implementation of
L<DBIx::Class::DeploymentHandler::HandlesVersioning>.  Pretty much all the
documentation is there.
