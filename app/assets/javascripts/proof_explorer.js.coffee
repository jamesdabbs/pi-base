class ProofExplorer
  constructor: () ->
    @w = 600
    @h = 600

  bound: (val, min, max) ->
    Math.max min, Math.min(val, max)

  focus: (trait) ->
    $('#info_pane').html JST['info_pane'](trait: trait, graph: @graph)
    MathJax.Hub.Queue ["Typeset", MathJax.Hub]

  done_loading: () ->
    $(".loading").remove()
    $("#info_pane").html $ "<h3>Proof Explorer</h3><p>Mouse over a node to the left for a description of that trait.</p>"

  render: (selector) ->
    force = d3.layout.force()
        .charge(-150)
        .linkDistance(50)
        .size [@w, @h]

    color = d3.scale.category20()

    svg = d3.select(selector).append("svg")
        .attr("width",  @w)
        .attr("height", @h)

    # From http://logogin.blogspot.com/2013/02/d3js-arrowhead-markers.html
    svg.append("defs").append("marker")
        .attr("id",    "arrowhead")
        .attr("class", "arrowhead")
        .attr("refX", 9)
        .attr("refY", 2)
        .attr("markerWidth",  6)
        .attr("markerHeight", 4)
        .attr("orient", "auto")
      .append("path")
        .attr("d", "M 0,0 V 4 L6,2 Z")


    d3.json document.URL + ".json", (error, graph) =>
      @graph = graph
      @done_loading()

      force
          .nodes(graph.nodes)
          .links(graph.links)
          .start()

      link = svg.selectAll(".link")
          .data(graph.links)
        .enter().append("line")
          .attr("class", "link")
          .attr("marker-end", "url(#arrowhead)")
          .style("stroke-width", 2)

      node = svg.selectAll(".node")
          .data(graph.nodes)
        .enter().append("circle")
          .attr("class", "node")
          .attr("r",       (d) -> if d.theorem then 6 else 10)
          .attr("fill",    (d) -> if d.root then color d.root else "#202020")
          .on("mouseover", (d) => @focus d)
          .on("click",     (d) -> window.location = "/traits/" + d.id)
          .call(force.drag)

      node.append("title").text((d) -> d.name);

      force.on "tick", =>
        node.attr("cx", (d) => d.x = @bound d.x, 10, @w - 10)
            .attr("cy", (d) => d.y = @bound d.y, 10, @h - 10)
        link.attr("x1", (d) -> d.source.x)
            .attr("y1", (d) -> d.source.y)
            .attr("x2", (d) -> d.target.x)
            .attr("y2", (d) -> d.target.y)

window.brubeck ?= {}
window.brubeck.ProofExplorer = ProofExplorer