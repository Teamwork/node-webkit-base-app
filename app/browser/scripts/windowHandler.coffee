TrayHandler = require './trayHandler'

class WindowHandler

    isShown: false
    isMinimizedToTray: false

    constructor: (@gui = nequire('nw.gui')) ->
        @platform = global.app.platform
        @window = @gui.Window.get()

        @showTrayIcon() unless @platform.isLinux

        $ =>
            @$windowActions = $('.window-actions')
            @$minimizeButton = @$windowActions.find('.window-minimize')
            @$maximizeButton = @$windowActions.find('.window-maximize')
            @$restoreButton = @$windowActions.find('.window-restore')
            @$closeButton = @$windowActions.find('.window-close')
            @attachEvents()

    attachEvents: () =>
        @window.on 'close', @onClose

        @$windowActions
            .on 'click.WindowHandler', '.window-minimize', @minimize
            .on 'click.WindowHandler', '.window-maximize', @maximize
            .on 'click.WindowHandler', '.window-restore', @restore
            .on 'click.WindowHandler', '.window-close', @onClose

    onClose: () =>
        if @platform.isLinux
            @minimize()
        else
            @minimizeToTray()

    close: () =>
        @window.close()
        @isShown = false

    hide: () =>
        @window.hide()
        @isShown = false

    minimize: () =>
        @window.minimize()
        @isShown = false

    minimizeToTray: () =>
        if @platform.isMac
            @minimize()
        else
            @hide()

        @isMinimizedToTray = true

    maximize: () =>
        @window.maximize()
        @$maximizeButton.addClass('hide')
        @$restoreButton.removeClass('hide')
        @isShown = true

    restore: () =>
        @window.restore()
        @$maximizeButton.removeClass('hide')
        @$restoreButton.addClass('hide')
        @isShown = true

    restoreFromTray: () =>
        if @platform.isMac
            @restore()
        else
            @show()

        @isMinimizedToTray = false

    show: () =>
        @window.show()

    showFromTrayMenu: () =>
        return if @isShown
        if @isMinimizedToTray
            @restoreFromTray()
        else
            @show()

    showDevTools: () =>
        @window.showDevTools()

    showTrayIcon: () =>
        @trayHandler = new TrayHandler( this, @gui )
        @trayHandler.show()
        global.app.trayHandler = @trayHandler

    exit: () =>
        @gui.App.quit()

module.exports = WindowHandler