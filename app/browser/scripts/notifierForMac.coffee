# Private: Notification handler for Mac (goes to notification centre, etc.)
module.exports = class NotifierForMac

    constructor: () ->
        @nodeNotifier = nequire('node-notifier')

    # Public: main method
    notify: (title, message) =>
        @nodeNotifier.notify
            title: title,
            message: message

    # Public: needed to satisfy the {Notifier} interface but does nothing.
    hideAll: () =>
        # do Nothing