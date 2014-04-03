WindowHandler = require './windowHandler'

class KeyCatcher

    constructor: (@window = global.app.windowHandler) ->
        $ =>
            @attachEvents()

    attachEvents: () =>
        for binding in @keyBindings()
            Mousetrap.bind binding.keys, binding.action

    keyBindings: =>
        [
            {
                keys: 'esc',
                action: () =>
                    @window.showDevTools()
            },
            {
                keys: ['ctrl+s', 'command+s'],
                action: () =>
                    console.log 'Array of keys example'
            }
        ]

module.exports = KeyCatcher