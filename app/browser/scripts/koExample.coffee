koMessage = require './koObjectExample'

class ExampleViewModel

    allMessages: ko.observableArray([])
    searchText: ko.observable("")
    loading: ko.observable(true)

    constructor: (opts) ->
        @el = opts.el || "#koExample"

        @messages = ko.computed =>
            filter = @searchText().toLowerCase()
            unless filter
                filtered = @allMessages()
            else
                filtered = ko.utils.arrayFilter @allMessages(), (message) =>
                    message.content.toLowerCase().indexOf(filter) != -1

        @getData()

    getData: () ->
        $.ajax 'http://jsonstub.com/messages',
        type: 'GET',
        beforeSend: (request) ->
            request.setRequestHeader('JsonStub-User-Key', '6d742525-2702-4b00-af84-ab4c8918f549')
            request.setRequestHeader('JsonStub-Project-Key', '1e08af91-6a73-4382-a230-ef312610d0fa')
        success: (data) =>
            for message in data.messages
                @addMessage(message)
            @loading(false)
        return true

    addMessage: (data) ->
        message = new koMessage
            author: data.author
            time: data.time
            content: data.content
        @allMessages.push(message)

module.exports = ExampleViewModel