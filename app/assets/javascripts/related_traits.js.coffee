window.pi_base.RelatedTraits = class RelatedTraits
  constructor: (selector) ->
    @$el = $(selector || '#traits')

    @$el.html $ '<p>Loading related Traits <i class="icon-spinner icon-spin"></i>'

    @fetch_traits (traits) =>
      i = 0
      _.each _(traits).keys(), (group) ->
        members = traits[group]
        if members.length == 0
          delete traits[group]
          return

        traits[group] =
          members: members
          id:      'related-' + i
        i += 1
      @$el.html JST['related_traits'] traits:traits
      pi_base.render_latex @$el[0]
      
      @$el.find('.form-search').keyup (e) =>
        pi_base.delay 200, () =>
          @filter @$el.find('.form-search input').val()

      @$el.find('a[data-toggle="tab"]').first().click()

  fetch_traits: (cb) ->
    $.ajax 
      url: window.location.pathname + '/related.json'
      success: cb
      error: (xhr, text, err) ->
        console.log 'Could not fetch related traits:', text, err

  filter: (val) ->
    # TODO: make this a Backbone view. Paginate?
    val = val.toLowerCase()
    @$el.find('.tab-pane li').each (i, li) ->
      $li = $(li)
      if $li.data('name').indexOf(val) == -1
        $li.hide()
      else
        $li.show()