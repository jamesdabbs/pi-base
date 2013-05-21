window.brubeck.RelatedTraits = class RelatedTraits
  constructor: () ->
    @fetch_traits (traits) ->
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
      $('#traits').html JST['related_traits'] traits:traits

  fetch_traits: (cb) ->
    $.ajax 
      url: window.location.pathname + "/related.json"
      success: cb
      error: (xhr, text, err) ->
        console.log "Could not fetch related traits:", text, err