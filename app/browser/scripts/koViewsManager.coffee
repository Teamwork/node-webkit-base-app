class KoViewsManager

    views: {}

    register: (view) ->
        sel = view.el
        el = $(sel)[0]
        @remove(sel)
        @views[sel] = view
        ko.applyBindings(view, el)

    remove: (sel) ->
        if @views[sel]
            delete @views[sel]
            ko.cleanNode($(sel)[0])

module.exports = KoViewsManager