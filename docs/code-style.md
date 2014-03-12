**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [CSS](#css)
	- [LESS](#less)
- [HTML](#html)
- [JavaScript](#javascript)
	- [CoffeeScript](#coffeescript)
	- [jQuery](#jquery)

# CSS

- No inline styles.
- Write everything in [LESS](http://lesscss.org).
- Use `/*! important text here */` style for any comments that are to exist in the end CSS file are all processing is done.
- Try not to reference tag names. Use classes instead. CSS should be as de-coupled from markup as possible.
- Don't over-qualify selectors; e.g. `div#top`.
- Try and use `is-` prefix for states. E.g. `.is-pushed` instead of `.pushed`.
- Place media queries as close to their relevant rule sets whenever possible. Don't bundle them all in a separate stylesheet or at the end of the document.

## LESS

- Put all colour values in `colors.less`.
- Create and re-use mixins as much as possible. Store them in `mixins.less`.
- Do not use *any* vendor prefixes. This is to be handled by [autoprefixer](http://github.com/ai/autoprefixer).
- Try to (re-)use as many variables (initialized in `variables.less`) as possible. Base variable values on other variables; `@anotherVariable + 10`, `darken(@yetAnotherVariable, 20%)`, etc.
- Don't reference colour variables form `colors.less` anywhere but in `variables.less`. E.g. In `button.less`, set a `background: @buttonBackground`. In `variables.less`, define `@buttonBackground: @white`. In `colours.less`, define `@white: #fff`.
- Keep hierarchy simple. If a `.menu` is nested seven levels deep inside `.box`, then just write `.box { .menu { /* ... */ } }` or even just `.menu { /* ... */ }` if you can get away with it (bonus points for re-usability).

# HTML

- Write everything in [Jade](http://jade-lang.com/).
- IDs are unique.
- Use semantic classes.
- No inline styles or scripting.

# JavaScript

- No inline scripting.
- Write everything in [CoffeeScript](http://coffeescript.org).
- Variable names should be in camelCase.
- Boolean variable names should start with `is`, e.g. `isHorizontal`.
- Boolean variable names shouldn't be negative; i.e. `isShown = true` is better than `isHidden = false`.
- Functions can only have boolean parameters if:
    - There is only one parameter
    - It's semantic and obvious what `true` / `false` signifies without having to look at the function implementation.
- If there are multiple parameters including a boolean or multiple, then use an object parameter so the booleans are named. Make sure to follow Biscotto's convention for describing object parameters.
- Try not to use abbreviations / shorthand in variable names and comments.

## CoffeeScript

- Use [biscotto](http://github.com/atom/biscotto) style comments in CoffeeScript classes.
- When using another CoffeeScript class, only use methods defined as public in the biscotto-style comments (or as shown in the generated docs).
- `nequire` is for requiring Node modules. `require` is used for requiring other CoffeeScripts (uses Browserify).
- When defining a function, use the fat function arrow (`=>`) unless you definitely will be referencing a property from the context in which the function will be called. I.e. `$buttons.on 'click', () -> console.debug 'index of clicked element' + @.index`.
- Don't use `@` on it's own, use `this` instead. Only use `@` when referring to properties (i.e. `@closeTab`).

## jQuery

- Prefix a variable name with `$` if it contains a jQuery object. Otherwise, never use the `$` prefix. E.g. `$button = $('.button')` but `numberOfButtons = $button.length`.
- When querying the DOM for just one element, use `$('.nav').first()` or `$('.nav').eq(0)` or by ID if you can (fastest). Using the `:eq` / `:first` pseudo-selectors would be slower than `.eq()` / `.first()`.
- If you're querying the DOM for something by ID then class / etc. like `$('#nav .first')`, instead separate the ID query from the rest; `$('#nav').find('.first')` (jQuery / Sizzle eventually does this internally anyway, but it's just that little bit faster if you do it yourself).
- Chain queries. For example:
    ```js
    $('.nav')
    .on('focus', onNavFocus)
    .find('a').on('click', onNavItemClick)
    .filter(':first').on('blur', onFirstNavItemBlur)
    .end().end() //returns to .nav query
    .find('.skip-content').on('click', skipNavContent)
    ```
- Use event delegation. For example:
    ```js
    $('.nav')
    .on('click', 'li', onNavItemClick)
    .on('click', 'a', onNavLinkClick)
    ```
