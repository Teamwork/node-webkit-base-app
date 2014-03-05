WindowHandler = require './windowHandler'

class KeyCatcher

    constructor: (@window = global.app.windowHandler) ->
        @attachEvents()

    attachEvents: () =>
        $ =>
            $(document).on 'keyup', (e) =>
                @onKeyUp()[e.keyCode](e) if @onKeyUp()[e.keyCode]?

    onKeyUp: =>
        27: () =>
            @window.showDevTools()


module.exports = KeyCatcher