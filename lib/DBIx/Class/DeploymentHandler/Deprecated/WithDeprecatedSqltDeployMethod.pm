package DBIx::Class::DeploymentHandler::Deprecated::WithDeprecatedSqltDeployMethod;
use Moose::Role;

# ABSTRACT: (DEPRECATED) Use this if you are stuck in the past

use DBIx::Class::DeploymentHandler::DeployMethod::SQL::Translator::Deprecated;

has deploy_method => (
  does => 'DBIx::Class::DeploymentHandler::HandlesDeploy',
  is  => 'ro',
  lazy_build => 1,
  handles =>  'DBIx::Class::DeploymentHandler::HandlesDeploy',
);

has upgrade_directory => (
  isa      => 'Str',
  is       => 'ro',
  required => 1,
  default  => 'sql',
);

has databases => (
  coerce  => 1,
  isa     => 'DBIx::Class::DeploymentHandler::Databases',
  is      => 'ro',
  default => sub { [qw( MySQL SQLite PostgreSQL )] },
);

has sql_translator_args => (
  isa => 'HashRef',
  is  => 'ro',
  default => sub { {} },
);

sub _build_deploy_method {
  my $self = shift;
  DBIx::Class::DeploymentHandler::DeployMethod::SQL::Translator::Deprecated->new({
    schema              => $self->schema,
    databases           => $self->databases,
    upgrade_directory   => $self->upgrade_directory,
    sql_translator_args => $self->sql_translator_args,
  });
}

1;

# vim: ts=2 sw=2 expandtab

__END__

=head1 DEPRECATED

This component has been suplanted by
L<DBIx::Class::DeploymentHandler::WithSqltDeployMethod>.
In the next major version (1) we will begin issuing a warning on it's use.
In the major version after that (2) we will remove it entirely.

=head1 DELEGATION ROLE

This role is entirely for making delegation look like a role.  The actual
docs for the methods and attributes are at
L<DBIx::Class::DeploymentHandler::DeployMethod::SQL::Translator::Deprecated>
