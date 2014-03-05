# Private: Desktop notifications
module.exports = class NotifierForDesktop

    ### Internal: some properties ###

    WINDOW_WIDTH: 290
    WINDOW_HEIGHT: 500
    notificationsWindow: null
    isNotificationWindowShown: false
    numberOfNotificationsShown: 0
    limitForTruncatingMessages: 5
    notificationInterval: 4000 #ms
    template: 'notification.html'

    notificationWindowOptions:
        frame: false
        toolbar: false
        width: @WINDOW_WIDTH
        height: @WINDOW_HEIGHT
        'always-on-top': true
        show: false
        show_in_taskbar: false
        resizable: false




    ### Public ###

    # icon - Optional {String}
    constructor: (@icon = '') ->
        @gui = nequire 'nw.gui'


    # title - {String}
    # content - {String}, will be truncated
    # onClick - Optional {Function}
    # returns {Boolean}
    notify: (title, content, onClick) =>
        return false unless @gui
        @openNewNotificationsWindow() unless @notificationsWindow
        continuation = () =>
            @appendNotificationToWindow title, content, onClick
            @slideInNotificationsWindow()
            @processNotifications()

        if @isWindowLoaded
            continuation()
        else
            @notificationsWindow.on 'loaded', continuation
        return true


    hideAll: () =>
        return false unless @gui

        if @notificationsWindow?
            @notificationsWindow.close true
            @notificationsWindow = null



    ### Internal ###

    openNewNotificationsWindow: () =>
        @notificationsWindow = @gui.Window.open @template, @notificationWindowOptions
        @isWindowLoaded = false

        @notificationsWindow.on 'loaded', () =>
            @isWindowLoaded = true
            $(@notificationsWindow.window.document.body).find('.close-notification-icon').on 'click', () =>
                @slideOutNotificationWindow()


    getUniqueId: () =>
        return (+(new Date())) + '-' + (@numberOfNotificationsShown++)

    # title - {String}
    # content - {String}
    # onClick - Optional {Function}
    appendNotificationToWindow: (title, content, onClick) =>
        elementID = @getUniqueId()
        markup = @makeNotificationMarkup title, content, elementID
        $body = @getBodyInNotificationsWindow()
        $body.find('.notifications').append(markup)
        $body.find( '#' + elementID ).on 'click', onClick if onClick?


    # shows the window with an animation
    slideInNotificationsWindow: () =>
        return if @isNotificationWindowShown
        y = screen.availTop
        x = @WINDOW_WIDTH
        @notificationsWindow.moveTo @getXPositionOfNotificationWindow(@notificationsWindow), y
        @notificationsWindow.show()
        @isNotificationWindowShown = true
        animate = () =>
            setTimeout((() =>
                if y < 60
                    @notificationsWindow.resizeTo x, y
                    y += 10
                    animate()
            ), 5)
        animate()


    # callback - Optional {Function}
    slideOutNotificationWindow: (callback) =>
        y = @notificationsWindow.height
        x = @WINDOW_WIDTH
        animate = () =>
            setTimeout((() =>
                if y >- 10
                    @notificationsWindow.resizeTo(x,y)
                    y -= 10
                    animate()
                else
                    @notificationsWindow.hide()
                    callback() if callback?
            ), 5)
        animate()
        @isNotificationWindowShown = false


    # returns {Number}
    getXPositionOfNotificationWindow: () =>
        return screen.availLeft + screen.availWidth - (@WINDOW_WIDTH + 10)

    # returns new notification list-item as a {String}
    makeNotificationMarkup: (title, content, id) =>
        idAttribute = if id? then " id='#{id}'" else ''

        return """
            <li#{idAttribute}>
                <div class='icon'>
                    <img src='#{@icon}' />
                </div>
                <div class='title'>#{@truncate(title, 35)}</a></div>
                <div class='description'>#{@truncate(content, 37)}</div>
            </li>
            """


    # str - {String} to be truncated
    # str - max-length ({Number})
    truncate: (str, length) =>
        str = $.trim(str)
        if str.length > length
            return $.trim( str.substr(0,length) ) + '...'
        else
            return str

    # This handles the showing of new notifications and hiding of old ones.
    # It'll also close the notifications window if there are no notifications left.
    # Plus it will take a max-notifications threshold into account and tell the user you have "X new notifications".
    processNotifications: () =>
        $notificationsList = @getNotificationsListInWindow()
        $notifications = $notificationsList.find '> li'

        continuation = () =>
            $notifications = @getNotificationsListInWindow().find '> li'
            numberOfNotifications = $notifications.length
            if !numberOfNotifications
                #lets close the window
                @getBodyInNotificationsWindow().find('.close-notification-icon').trigger 'click'
                return
            else if numberOfNotifications > @limitForTruncatingMessages
                $notificationsList.html @makeNotificationMarkup('Teamwork Chat', numberOfNotifications + ' new notifications')

            $notifications = @getNotificationsListInWindow().find '> li' # needs to re-query
            $notifications.first().fadeIn 'fast'
            setTimeout @processNotifications, @notificationInterval
        #end of function

        $firstNotification = $notifications.first()
        if $firstNotification.is ':visible'
            $firstNotification.fadeOut 'fast', () =>
                $firstNotification.remove()
                continuation()
        else
            continuation()

    # Reachs into the notification window and grabs the list of notifications. Depends on the markup / class.
    getNotificationsListInWindow: () =>
        return @getBodyInNotificationsWindow().find '.notifications'

    # Reachs into the notification window and grabs the <body>
    # Returns {jQuery}
    getBodyInNotificationsWindow: () =>
        return $ @notificationsWindow.window.document.body