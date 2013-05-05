class TraitTable
  constructor: (selector) ->
    @$el = $(selector)

  render: () ->
    $.getJSON document.URL + '.json', (data) =>
      @$el.html JST['trait_table'] data

window.brubeck ?= {}
window.brubeck.TraitTable = TraitTable