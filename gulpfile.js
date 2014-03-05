/* ------------------------
 * Dependencies
 * ----------------------- */
var gulp = require('gulp');
var gutil = require('gulp-util');
var less = require('gulp-less');
var minifyCSS = require('gulp-minify-css');
var coffee = require('gulp-coffee');
var coffeelint = require('gulp-coffeelint');
var coffeelintThreshold = require('gulp-coffeelint-threshold');
var browserify = require('gulp-browserify');
var jade = require('gulp-jade');
var clean = require('gulp-clean');
var rename = require('gulp-rename');
var replace = require('gulp-replace');
var concat = require('gulp-concat');
var imagemin = require('gulp-imagemin');
var gulpGrunt = require('gulp-grunt');
var autoprefixer = require('gulp-autoprefixer');
var debug = require('gulp-debug');
var getMainBowerFiles = require('gulp-bower-files');
var combinePipes = require('lazypipe');


/* ----------------------------------------
 * Paths; all paths and globs used in tasks
 * ---------------------------------------- */
var paths = {
    app: './app/',
    background: {},
    browser: {},
    public: {}
};

// background
paths.background.root = paths.app;
paths.background.scriptsRoot = paths.background.root + 'scripts/';
paths.background.scripts = paths.background.scriptsRoot + '*.coffee';
paths.background.dependencies = paths.background.root + 'node_modules/**';
paths.background.packageJSON = paths.background.root + 'package.json';

// browser
paths.browser.root = paths.app + 'browser/';
paths.browser.appScriptsRoot = paths.browser.root + 'scripts/';
paths.browser.appScripts = paths.browser.appScriptsRoot + '*.coffee';
paths.browser.appEntryScript = paths.browser.appScriptsRoot + 'app.coffee';
paths.browser.fonts =  paths.browser.root + 'fonts/*';
paths.browser.images =  paths.browser.root + 'images/*';
paths.browser.stylesRoot = paths.browser.root + 'style/';
paths.browser.styles = paths.browser.stylesRoot + '*.less';
paths.browser.styleEntryFile = paths.browser.stylesRoot + 'app.less';
paths.browser.templatesRoot = paths.browser.root + 'templates/';
paths.browser.templates = paths.browser.templatesRoot + '*.jade';
paths.browser.templatePartials = paths.browser.templatesRoot + 'partials/*.jade';
paths.browser.dependencies = paths.browser.root + 'third-party/**';

// public
paths.public.root = './_public/';
paths.public.cssRoot = paths.public.root + 'css';
paths.public.fontsRoot =  paths.public.root + 'fonts';
paths.public.imagesRoot = paths.public.root + 'images';
paths.public.browserScriptsRoot =  paths.public.root + 'js';
paths.public.backgroundRoot =  paths.public.root + 'background/';
paths.public.backgroundScripts =  paths.public.backgroundRoot;
paths.public.dependencies =  paths.public.root + 'node_modules';



/* ---------------------------------------------------------------------
 * Grunt; import tasks from Gruntfile (needs to come before Gulp tasks)
 * --------------------------------------------------------------------- */
gulpGrunt(gulp, {
    base: './'
});




/* ---------------------------------------------------------------------
 * Re-usable functions for Gulp tasks
 * --------------------------------------------------------------------- */

/*
 * browserify's and node's require() clash.
 * So we're using nequire for requiring node modules and require for broweserify modules.
 * This function replaces require with requireClient and nequire with require.
 */
var requireWorkaround = combinePipes()
    .pipe(replace, 'require', 'requireClient')
    .pipe(replace, 'nequire', 'require');

var lintCoffeeWithThreshold = combinePipes()
    .pipe(coffeelint, './coffeelint.json')
    .pipe(coffeelint.reporter)
    .pipe(coffeelintThreshold, -1, 0, function(numberOfWarnings, numberOfErrors){
        gutil.beep();
        throw new Error('CoffeeLint failure; see above. Warning count: ' + numberOfWarnings
            + '. Error count: ' + numberOfErrors + '.');
    });





/* ---------------------------------------------------------------------
 * Gulp tasks; app-level stuff
 * --------------------------------------------------------------------- */

gulp.task('default', ['compile']);

gulp.task('nodewebkit', ['grunt-nodewebkit']);//depends on this task existing in the Gruntfile

gulp.task('compile', ['compile-background', 'compile-browser', 'assets']);

gulp.task('assets', function(){
    gulp.src(paths.background.dependencies)
        .pipe(gulp.dest(paths.public.dependencies));

    gulp.src(paths.background.packageJSON)
        .pipe(gulp.dest(paths.public.root));
});

gulp.task('clean', function(){
    gulp.src(paths.public.root, { read: false })
        .pipe(clean());
});

gulp.task('compile-watch', ['compile'], function(){
    //background
    gulp.watch([paths.background.dependencies, paths.background.packageJSON], ['assets']);
    gulp.watch([paths.background.scripts], ['background-scripts']);

    //browser
    gulp.watch([paths.browser.dependencies], ['browser-dependencies']);
    gulp.watch([paths.browser.fonts], ['fonts']);
    gulp.watch([paths.browser.images], ['images']);
    gulp.watch([paths.browser.appScripts], ['browser-scripts']);
    gulp.watch([paths.browser.styles], ['styles']);
    gulp.watch([paths.browser.templates, paths.browser.templatePartials], ['templates']);
});

gulp.task('lint', function(){
    // Generate a nice report of all lint errors
    gulp.src([paths.background.scripts, paths.browser.appScripts])
        .pipe(coffeelint('./coffeelint.json'))
        .pipe(coffeelint.reporter('default'))
});


/* ---------------------------------------------------------------------
 * Gulp tasks; tasks for the background of the app
 * --------------------------------------------------------------------- */

gulp.task('compile-background', ['assets', 'background-scripts']);

gulp.task('background-scripts', function(){
    gulp.src(paths.background.scripts)
        .pipe(lintCoffeeWithThreshold())
        .pipe(coffee())
        .pipe(requireWorkaround())
        .pipe(gulp.dest(paths.public.backgroundScripts));
});




/* ---------------------------------------------------------------------
 * Gulp tasks; tasks for the browser-side of the app
 * --------------------------------------------------------------------- */

gulp.task('compile-browser', ['fonts', 'images', 'browser-scripts', 'styles', 'templates', 'browser-dependencies']);

gulp.task('fonts', function(){
    gulp.src(paths.browser.fonts)
        .pipe(gulp.dest(paths.public.fontsRoot));
});

gulp.task('images', function(){
    gulp.src(paths.browser.images)
        .pipe(imagemin())
        .pipe(gulp.dest(paths.public.imagesRoot));
});

gulp.task('styles', function(){
    gulp.src(paths.browser.styleEntryFile)
        .pipe(less())
        .pipe(minifyCSS())
        .pipe(autoprefixer('Chrome >= 32'))
        .pipe(gulp.dest(paths.public.cssRoot));
});

gulp.task('browser-scripts', function(){
    gulp.src(paths.browser.appScripts)
        .pipe(lintCoffeeWithThreshold());

    gulp.src(paths.browser.appEntryScript, {read:false})
        .pipe(browserify({
            transform: ['coffeeify'],
            extensions: ['.coffee']
        }))
        .pipe(requireWorkaround())
        .pipe(rename('app.js'))
        .pipe(gulp.dest(paths.public.browserScriptsRoot));
});

gulp.task('browser-dependencies', function(){
    getMainBowerFiles()
        .pipe(concat('third-party.js'))
        .pipe(gulp.dest(paths.public.browserScriptsRoot));
});

gulp.task('templates', function(){

    gulp.src([paths.browser.templates])
        .pipe(jade({
            pretty: true
        }))
        .pipe(gulp.dest(paths.public.root));


    gulp.src([paths.browser.templatePartials])
        .pipe(jade({
            client: true
        }))
        .pipe(concat('partials.js'))
        .pipe(gulp.dest(paths.public.browserScriptsRoot));
});