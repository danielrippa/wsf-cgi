
  { handle-request, new-response-headers } = dependency cgi.Request
  { mime-types } = dependency cgi.MimeTypes
  { value-as-string: value, primitive-type-name: type-name, primitive-type-names: p } = dependency primitive.Type
  { new-element, stylesheet, script } = dependency html.Element
  { process-named } = dependency wmi.Process
  { stringify } = dependency wscript.Json
  { run } = dependency wmi.Exec

  jellyfin = -> process-named 'jellyfin.exe'

  is-jellyfin-running = -> jellyfin! isnt void

  jellyfin-start = -> run "e:\\shared-tools\\jelly-start.cmd"

  button = (id, caption) ->

    elem = new-element \button class: \button, id: id, type: \submit, hx-get: \status.wsf, hx-target: '#columns', hx-swap: 'outerHTML', hx-vals: stringify action: id

      ..text caption

    switch id

      | \start =>

        if is-jellyfin-running!
          elem.attr disabled: ''

      | \stop  =>

        if not is-jellyfin-running!
          elem.attr disabled: ''

    elem

  columns = ->

    new-element \div id: \columns, class: 'columns is-centered'

      .. \div class: 'column is-half'

        ..add button \start, \Start

      .. \div class: 'column is-half'

        ..add button \stop, \Stop

  handle-request (query, request, server, post-data) ->

    response-headers = new-response-headers!

      ..content-type mime-types.html

    document = switch query.action

      | \start => jellyfin-start! ; columns!

      | \stop => jellyfin!Terminate! ; columns!

      else

        new-element \html

          .. \head

            .. \meta name: \viewport, content: "width=device-width", initial-scale: \1.0

            ..add stylesheet '/css/bulma.css'
            ..add script '/js/htmx.js'

          .. \body

            ..add columns!

    content = [ document.to-string! ]
    headers = response-headers.as-list!

    { content, headers }
