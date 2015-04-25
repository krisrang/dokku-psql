#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PSQL_ROOT"
  dokku apps:create testapp
  # $dokkucmd psql:start
}

teardown() {
  # dokku apps:destroy testapp
  rm -rf "$DOKKU_ROOT"
}

@test "psql:create requires an app name" {
  run dokku psql:create
  assert_exit_status 1
  assert_output "(verify_app_name) APP must not be null"
}

@test "psql:create creates files and sets env" {
  run dokku psql:create testapp
  assert_db_exists
  assert_success
  assert_output "-----> Creating database testapp
-----> Setting config vars for testapp"
  run dokku config testapp
  assert_contains "$output" "DB_TYPE:        postgresql"
}

@test "psql:delete deletes database" {
  run dokku psql:create testapp
  assert_success
  run dokku psql:delete testapp
  assert_success
  assert_output "-----> Deleting database testapp
-----> Unsetting config vars for testapp"
  [ ! -f "$PSQL_ROOT/db_testapp" ]
}

@test "psql:list lists databases" {
  run dokku psql:create testapp
  run dokku psql:list --quiet
  assert_success
  assert_output "exec called with exec --interactive --tty dokku-psqlkr env TERM=$TERM psql -h localhost -U postgres -c \l"
}

@test "psql:url returns psql url" {
  run dokku psql:create testapp
  run dokku psql:url testapp
  PASS=$(cat "$PSQL_ROOT/pass_testapp")
  assert_success
  assert_output "postgresql://testapp:$PASS@postgres:5432/testapp"
}

@test "psql:console calls docker exec" {
  run dokku psql:create testapp
  run dokku psql:console testapp
  PASS=$(cat "$PSQL_ROOT/pass_testapp")
  assert_success
  assert_output "exec called with exec --interactive --tty dokku-psqlkr env TERM=$TERM PGPASSWORD=$PASS psql -h localhost -U testapp testapp"
}

@test "psql:stop stops psql container" {
  run dokku psql:stop
  assert_success
  assert_output "-----> Stopping Postgresql server"
}

@test "psql:dump feeds database dump" {
  run dokku psql:create testapp
  run dokku psql:dump testapp
  assert_success
  assert_output "pg_dump"
}

@test "psql:docker_args gives correct link" {
  run dokku psql:create testapp
  run bash -c "echo 'test' | dokku psql:docker_args testapp"
  assert_success
  assert_output "test --link dokku-psqlkr:postgres"
}
