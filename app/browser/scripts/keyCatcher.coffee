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
                keys: ['a b', 'c d'],
                action: () =>
                    alert('stuff')
            }
        ]

module.exports = KeyCatcher