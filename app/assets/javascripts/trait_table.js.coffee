window.brubeck.TraitTable = class TraitTable
  constructor: (selector) ->
    @$el = $(selector)

  render: () ->
    $.getJSON document.URL + '.json', (data) =>
      @$el.html JST['trait_table'] data
      brubeck.render_latex()
