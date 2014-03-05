class TrayHandler

    constructor: (@windowHandler, @gui = nequire('nw.gui')) ->
        @show()

    attachEvents: () =>
        return unless @trayIcon?
        @trayIcon.on 'click', () =>
            @onClick()

    onClick: () =>
        @windowHandler.restoreFromTray()

    show: () =>
        return if @trayIcon?

        @trayIcon = new @gui.Tray { icon: 'images/trayIcon.png' }
        @addMenu()
        @attachEvents()

    addMenu: () =>
        return unless @trayIcon?
        @menu = new @gui.Menu()

        @addMenuItem 'Show', @windowHandler.showFromTrayMenu
        @addMenuItem 'Exit', @windowHandler.exit

        @trayIcon.menu = @menu

    addMenuItem: (title, clickHandler) =>
        return unless @menu?
        menuItem = new @gui.MenuItem({label: title})
        menuItem.click = clickHandler if clickHandler?
        @menu.append(menuItem)

    hide: () =>
        return unless @trayIcon?
        @trayIcon.hide()
        @trayIcon = null


module.exports = TrayHandler