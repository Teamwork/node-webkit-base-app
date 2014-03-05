class KoViewsManager

    views: {}

    register: (view) ->
        el = $(view.el)[0]
        @remove(el)
        @views[el] = view
        ko.applyBindings(view, el)

    remove: (el) ->
        if @views[el]
            delete @views[el]
            ko.cleanNode(el)

module.exports = KoViewsManager