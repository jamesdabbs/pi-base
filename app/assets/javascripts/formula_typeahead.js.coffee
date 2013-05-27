parse = (query, properties, values) ->
  # Simple minded suggestion: if there are no ='s after the last separator
  # (that is, one of ()+&|), then suggest a property, otherwise a value
  separators = ['(', ')', '+', '&', '|']

  i = Math.max.apply null, $.map(separators, (s) -> query.lastIndexOf(s))
  # Advance to the last separator
  prefix  = query.slice 0, i+1
  current = query.slice i+1

  objs = if current.indexOf('=') != -1
    # Advance to the = sign ...
    j = current.indexOf('=')
    prefix += current.slice 0, j+1
    current = current.slice j+1
    values
  else
    # Consume a ~ if present
    neg = current.match /\s*~/
    prefix += neg[0] if neg
    properties

  # Standardize trailing whitespaces
  [prefix.replace(/([+&|=])\s*$/g, '$1 '), objs]


window.pi_base.FormulaTypeahead = class FormulaTypeahead
  constructor: (selector, properties, values) ->
    $(selector).typeahead
      source: (query, process) =>
        [prefix, objs] = parse query, properties, values
        $.map objs, (o) -> prefix + o
      matcher: (item) ->
        return false if @query.match /\)\s*$/
        [prefix, _] = parse @query
        curr = @query.slice(prefix.length).replace /^\s*/, ''
        item.toLowerCase().indexOf(curr.toLowerCase()) != -1
