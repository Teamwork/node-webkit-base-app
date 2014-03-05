node-webkit-base-app
========================

Bootstrap your [node-webkit](https://github.com/rogerwang/node-webkit) app. Similar idea to [node-webkit-hipster-seed](https://github.com/Anonyfox/node-webkit-hipster-seed), but with different stuff.

**Included:**

- Notifications (proper Mac ones for Mac OSX 10.8+, otherwise HTML ones)
- GulpJS (for compiling the app, watching for changes and more)
- Grunt (for packaging the app up for each platform, will be moved to Gulp once [node-webkit-builder#46](https://github.com/mllrsohn/grunt-node-webkit-builder/issues/46) is complete)
- Bower
- LESS
- Bootstrap 3 (LESS)
- Autoprefixing of CSS
- CoffeeScript
- CoffeeScript linting (deliberately fails the compilation step in order to enforce)
- Browserify
- jQuery 2
- KnockoutJS
- Jade templates
- nedb for persistent storage
- Lossless compression of images
- Code style docs

**To come:**

- Gulp task for generating documentation based on Biscotto CoffeeScript comments
- Automated integration tests
- Image conversion (to WebP)
- SVG icons


# Commands

## Global dependencies
1. `npm install -g bower` and make sure it's on your path.
2. `npm install -g gulp` and make sure it's on your path.

## Run

1. `npm start`

## Build

1. `npm install`
2. `bower install`
3. `cd app`
4. `npm install`

## Other useful commands

- `gulp clean` 
- `gulp lint`. Generates a nice CoffeeLint report.
- `gulp compile` (this is what `npm run compiler` calls)
- `gulp compile-watch`. This first compiles everything, then watches for any changes in the LESS, Coffeescripts, etc. and re-compiles what has changed. If you want to run this, you should open a second terminal to run `npm run app` once the re-compilation has finished.

# Notable files;

- `package.json`: Add any GulpJS dependencies here under devDependencies.
- `bower.json`: Any browser-side dependencies.
- `app/package.json`: [node-webkit manifest file](https://github.com/rogerwang/node-webkit/wiki/Manifest-format). List any node dependencies here needed in the end app (e.g. jQuery) and you can `nequire` them from your Coffescripts.
- `app/scripts/app.coffee`: JS entry point
- `app/style/app.less`: LESS root

# Docs

- [Coding style guide](docs/code-style.md)
- [Keyboard shortcuts](docs/keyboard-shortcuts.md)
