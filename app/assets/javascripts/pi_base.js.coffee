window.pi_base =
  render_latex: (el) ->
    if el
      MathJax.Hub.Queue ["Typeset", MathJax.Hub, el]
    else
      MathJax.Hub.Queue ["Typeset", MathJax.Hub]

  delay: (() ->
    timer = 0
    (ms, cb, args...) ->
      clearTimeout timer
      timer = setTimeout ->
        cb(args...)
      , ms
  )()
