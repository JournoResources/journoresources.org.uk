# journoresources.org.uk

This is the repository for code relating to the [Journo Resources website](https://www.journoresources.org.uk).

Currently this includes:
  - A `docker-compose` file to run WordPress locally
  - A plugin to create and display job listings on the JR [jobs page](https://www.journoresources.org.uk/journalism-jobs-internships)

## Development

### Run WordPress

```
docker-compose up
```

The `wp-content/plugins` directory inside the container will automatically be
linked to the same path in this repository.

#### Permissions issues

If you run into problems with permissions issues when trying to install themes
or plugins:
  - SSH into the running `wp` Docker container (`docker exec -it <id> /bin/bash`)
  - Run `chown -R www-data:www-data wp-content`
  - If it still doesn't work, add `define('FS_METHOD', 'direct');` to the
    `wp-config.php` inside the container

### Job listings plugin

The admin-facing part of the plugin is built on top of [ACF](https://www.advancedcustomfields.com),
which is bundled inside the `vendor` directory.

The public-facing list of jobs is displayed via a widget built in [Elm](http://elm-lang.org).
JavaScript dependencies are managed using [Yarn](https://yarnpkg.com/lang/en/).

The permalink settings inside WordPress need to be set to something other than
the default 'Plain' option for the WP JSON API to work.

To install dependencies:

```
cd public
yarn
```

To build the Elm app:

```
cd public
yarn build
```

To serve the app locally and watch files for changes:

```
cd public
yarn start
```

To build and package the whole plugin:

```
make build
```
