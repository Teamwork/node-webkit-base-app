WindowHandler = require './windowHandler'
KeyCatcher = require './keyCatcher'
Platform = require './platform'
Notifier = require './notifier'
KoViewsManager = require './koViewsManager'

KoExample = require './koExample'

global.app = {}
global.app.platform = new Platform()
global.app.windowHandler = new WindowHandler()
global.app.keyCatcher = new KeyCatcher()
global.app.notifier = new Notifier()
global.app.koViewsManager = new KoViewsManager()

$ =>
    global.app.koViewsManager.register(new KoExample({}))

    $('body').addClass('platform-' + global.app.platform.getPlatform())

    $('#notification-trigger').on 'click', (e) ->
        e.preventDefault()
        global.app.notifier.notify 'Notification ' + new Date().getTime(), 'This is a notification', () ->
            $('body').append('<p>Clicked on a notifcation!</p>')
