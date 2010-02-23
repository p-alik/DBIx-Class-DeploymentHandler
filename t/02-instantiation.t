#!perl

use Test::More;
use Test::Exception;

use lib 't/lib';
use DBICTest;
use DBIx::Class::DeploymentHandler;
my $db = 'dbi:SQLite:db.db';
my $sql_dir = 't/sql';

unlink 'db.db' if -e 'db.db';
mkdir 't/sql' unless -d 't/sql';

VERSION1: {
   use_ok 'DBICVersion_v1';
   my $s = DBICVersion::Schema->connect($db);
   ok($s, 'DBICVersion::Schema 1.0 instantiates correctly');
   my $handler = DBIx::Class::DeploymentHandler->new({
      upgrade_directory => $sql_dir,
      schema => $s,
      databases => ['SQLite'],
   });

   ok($handler, 'DBIx::Class::DeploymentHandler w/1.0 instantiates correctly');

   my $version = $s->schema_version();
   $handler->create_ddl_dir( $version, 0);
   ok(-e 't/sql/DBICVersion-Schema-1.0-SQLite.sql', 'DDL for 1.0 got created successfully');

   dies_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
      })
   } 'schema not deployed';
   $handler->install;
   lives_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
      })
   } 'schema is deployed';
}

VERSION2: {
   use_ok 'DBICVersion_v2';
   my $s = DBICVersion::Schema->connect($db);
   ok($s, 'DBICVersion::Schema 2.0 instantiates correctly');
   my $handler = DBIx::Class::DeploymentHandler->new({
      upgrade_directory => $sql_dir,
      schema => $s,
      databases => ['SQLite'],
   });

   ok($handler, 'DBIx::Class::DeploymentHandler w/2.0 instantiates correctly');

   $version = $s->schema_version();
   $handler->create_ddl_dir($version, 0);
   $handler->create_ddl_dir($version, '1.0');
   ok(-e 't/sql/DBICVersion-Schema-2.0-SQLite.sql', 'DDL for 2.0 got created successfully');
   ok(-e 't/sql/DBICVersion-Schema-1.0-2.0-SQLite.sql', 'DDL for migration from 1.0 to 2.0 got created successfully');
   dies_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
         baz => 'frew',
      })
   } 'schema not deployed';
   #$handler->install('1.0');
   dies_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
         baz => 'frew',
      })
   } 'schema not uppgrayyed';
   $handler->upgrade_single_step('1.0', '2.0');
   lives_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
         baz => 'frew',
      })
   } 'schema is deployed';
}

VERSION3: {
   use_ok 'DBICVersion_v3';
   my $s = DBICVersion::Schema->connect($db);
   ok($s, 'DBICVersion::Schema 3.0 instantiates correctly');
   my $handler = DBIx::Class::DeploymentHandler->new({
      upgrade_directory => $sql_dir,
      schema => $s,
      databases => ['SQLite'],
   });

   ok($handler, 'DBIx::Class::DeploymentHandler w/3.0 instantiates correctly');

   $version = $s->schema_version();
   $handler->create_ddl_dir( $version, 0);
   $handler->create_ddl_dir( $version, '1.0');
   $handler->create_ddl_dir( $version, '2.0');
   ok(-e 't/sql/DBICVersion-Schema-3.0-SQLite.sql', 'DDL for 3.0 got created successfully');
   ok(-e 't/sql/DBICVersion-Schema-1.0-3.0-SQLite.sql', 'DDL for migration from 1.0 to 3.0 got created successfully');
   ok(-e 't/sql/DBICVersion-Schema-2.0-3.0-SQLite.sql', 'DDL for migration from 2.0 to 3.0 got created successfully');
   dies_ok {
      $s->resultset('Foo')->create({
            bar => 'frew',
            baz => 'frew',
            biff => 'frew',
         })
   } 'schema not deployed';
   $handler->upgrade;
   lives_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
         baz => 'frew',
         biff => 'frew',
      })
   } 'schema is deployed';
}

done_testing;
__END__

vim: ts=2,sw=2,expandtab
