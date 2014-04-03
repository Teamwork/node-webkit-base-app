WindowHandler = require './windowHandler'

class KeyCatcher

    constructor: (@window = global.app.windowHandler) ->
        $ =>
            @attachEvents()

    attachEvents: () =>
        for binding of @eventHandlers()
            Mousetrap.bind binding, @eventHandlers()[binding]

    eventHandlers: =>
        'esc': (e) =>
            @window.showDevTools()

module.exports = KeyCatcher