# Public: Notifications root class. Delegates to {NotifierForDesktop} or {NotifierForMac}.
module.exports = class Notifier

    ### Public ###


    # icon - Optional {String}. Only used in {NotifierForDesktop}
    constructor: (@icon = '') ->
        platform = global.app.platform

        NotifierDelegate = if platform.isMac and platform.isOfMinimumVersion('12') then require './notifierForMac' else require './notifierForDesktop'
        @notifierDelegate = new NotifierDelegate(@icon)

    # Public: {Delgates to NotifierForDesktop.notify}
    notify: (title, content, onClick) =>
        @notifierDelegate.notify(title, content, onClick)

    # Public: {Delgates to NotifierForDesktop.hideAll}
    hideAll: () =>
        @notifierDelegate.hideAll()