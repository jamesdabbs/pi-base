class TraitTable
  constructor: (selector) ->
    @$el = $(selector)

  render: () ->
    $.getJSON document.URL + '.json', (data) =>
      @$el.html JST['trait_table'] data
      MathJax.Hub.Queue ["Typeset", MathJax.Hub]

window.brubeck ?= {}
window.brubeck.TraitTable = TraitTable