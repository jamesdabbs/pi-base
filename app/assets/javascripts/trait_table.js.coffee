window.pi_base.TraitTable = class TraitTable
  constructor: (selector) ->
    @$el = $(selector)

  render: (cb) ->
    @$el.dataTable
      bProcessing: false
      sAjaxSource: document.URL + '.json'
      bPaginate: false
      sScrollX: '100%'
      sScrollY: '500px'
      bScrollCollapse: true
      sDom: 'fti'

      fnDrawCallback: (settings) =>
        if @$el.find('tr').length < 3
          # FIXME: data tables doesn't expose enough control over this element, so we have to monkey patch it for now
          # Add styling classes
          filter = $('#trait-table_filter input')
            .addClass('search-query')
            .attr('placeholder', 'Type to filter')

          # Remove extraneous text
          filter.parent().contents().filter (i, n) ->
            @remove() if @nodeType == Node.TEXT_NODE

          # Move search bar into place
          $('.form-search').prepend filter.parent()
        else
          pi_base.render_latex @$el.find('tbody')[0]
