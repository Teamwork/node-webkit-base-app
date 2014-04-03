WindowHandler = require './windowHandler'

class KeyCatcher

    constructor: (@window = global.app.windowHandler) ->
        $ =>
            @attachEvents()

    attachEvents: () =>
        Mousetrap.bind 'esc', (e) =>
            @window.showDevTools()

module.exports = KeyCatcher