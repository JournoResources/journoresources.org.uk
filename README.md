# journoresources.org.uk

This is the repository for code relating to the [Journo Resources website](https://www.journoresources.org.uk).

Currently this includes:
  - A `docker-compose` file to run WordPress locally
  - A plugin to create and display job listings on the JR [jobs page](https://www.journoresources.org.uk/journalism-jobs-internships)

## Development

### Run WordPress

```
docker-compose
```

The `wp-content/plugins` directory inside the container will automatically be linked to the same path in this repository.

### Job listings plugin

The admin-facing part of the plugin is built on top of [ACF](https://www.advancedcustomfields.com), which is bundled inside the `vendor` directory.

The public-facing list of jobs is displayed via a widget built in [Elm](http://elm-lang.org). JavaScript dependencies are managed using [Yarn](https://yarnpkg.com/lang/en/).

To install dependencies:

```
yarn
```

To build the Elm app:

```
yarn build
```

To serve the app locally and watch files for changes:

```
yarn start
```
