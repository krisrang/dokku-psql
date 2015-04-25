dokku-psql [![Build Status](https://travis-ci.org/krisrang/dokku-psql.svg?branch=master)](https://travis-ci.org/krisrang/dokku-psql)
================

dokku-psql is a plugin for [dokku][dokku] that provides PostgreSQL servers for your applications.

It uses the official PostgreSQL docker image (version 9.4).

This version is tested against dokku 0.3.17.

## Installation

```
git clone https://github.com/krisrang/dokku-psql /var/lib/dokku/plugins/psqlkr
dokku plugins-install
```


## Commands
```
$ dokku help
    psql:admin_console                                 Launch a psql admin cli
    psql:console        <app>                          Launch a psql cli for <app>
    psql:create         <app>                          Create a psql database for <app>
    psql:delete         <app>                          Delete psql database for <app>
    psql:dump           <app> > <filename.rdb>         Dump <app> database to rdb file
    psql:list                                          List all databases
    psql:restart        <app>                          Restart the psql docker container for <app>
    psql:restore        <app> < <filename.rdb>         Restore database to <app> from rdb file
    psql:start                                         Start the psql docker container if it isn't running
    psql:status                                        Shows status of psql
    psql:stop                                          Stop the psql docker container
    psql:url            <app>                          Get DATABASE_URL for <app>
```

## Info
This plugin adds the following environment variables to your app via config vars (they are available via `dokku config <app>`):

* DATABASE\_URL
* POSTGRESQL\_URL
* DB\_HOST
* DB\_NAME
* DB\_DB
* DB\_USER
* DB\_PASS
* DB\_PORT

## Usage

### Start PostgreSQL:
```
$ dokku psql:start               # Server side
$ ssh dokku@server psql:start    # Client side
```

### Stop PostgreSQL:
```
$ dokku psql:stop                # Server side
$ ssh dokku@server psql:stop     # Client side
```

### Restart PostgreSQL:
```
$ dokku psql:restart             # Server side
$ ssh dokku@server psql:restart  # Client side
```

### Create a new database for an existing app:
```
$ dokku psql:create <app>              # Server side
$ ssh dokku@server psql:create <app>   # Client side
```

### Dump database:
```
$ dokku psql:dump <app> > filename.dump # Server side
```

### Restore database from dump:
```
$ dokku psql:restore <app> < filename.dump # Server side
```

### Copy database foo to database bar using pipe:
```
$ dokku psql:dump <app> | dokku psql:restore <app> # Server side
```

## Acknowledgements

This plugin is based originally on the [dokku-psql-single-container](https://github.com/Flink/dokku-psql-single-container).

## License

This plugin is released under the MIT license. See the file [LICENSE](LICENSE).

[dokku]: https://github.com/progrium/dokku
