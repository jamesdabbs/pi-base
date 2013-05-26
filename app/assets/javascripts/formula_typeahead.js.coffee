window.brubeck.FormulaTypeahead = class FormulaTypeahead
  constructor: (selector, properties, values) ->
    @$el        = $(selector)
    @properties = properties
    @values     = values

    @$el.typeahead
      source: (query, process) =>
        @suggest query

  suggest: (query) ->
    # Simple minded suggestion: if there are no ='s after the last separator
    # (that is, one of ()+&|), then suggest a property, otherwise a value
    separators = ['(', ')', '+', '&', '|']

    i = Math.max.apply null, $.map(separators, (s) -> query.lastIndexOf(s))
    # Advance to the last separator
    prefix  = query.slice 0, i+1
    current = query.slice i+1, -1

    if current.indexOf('=') != -1
      # Advance to the = sign ...
      j = current.indexOf('=')
      prefix += current.slice 0, j+1
      current = current.slice j+1, -1
      # and capture the leading whitespace
      ws = current.match /^\s+/
      prefix += ws[0] if ws
      $.map @values, (v) -> prefix + v
    else
      # Capture the leading whitespace
      ws = current.match /^\s+/
      prefix += ws[0] if ws
      $.map @properties, (p) -> prefix + p
