window.brubeck.RelatedTraits = class RelatedTraits
  constructor: (selector) ->
    @$el = $(selector || '#traits')

    @fetch_traits (traits) =>
      i = 0
      _.each _(traits).keys(), (group) ->
        members = traits[group]
        if members.length == 0
          delete traits[group]
          return

        traits[group] =
          members: members
          class:   if i == 0 then "active" else ""
          id:      "related-" + i
        i += 1
      @$el.html JST['related_traits'] traits:traits

      @$el.find('.form-search').keyup (e) =>
        brubeck.delay 200, () =>
          @filter @$el.find('.form-search input').val()

  fetch_traits: (cb) ->
    $.ajax 
      url: window.location.pathname + "/related.json"
      success: cb
      error: (xhr, text, err) ->
        console.log "Could not fetch related traits:", text, err

  filter: (val) ->
    # TODO: make this a Backbone view
    @$el.find('.tab-pane li').each (i, li) ->
      $li = $(li)
      if $li.data('name').indexOf(val) == -1
        $li.hide()
      else
        $li.show()