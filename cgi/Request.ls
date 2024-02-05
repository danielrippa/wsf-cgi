
  do ->

    { Fn, List, FieldSet, Str } = dependency primitive.Types
    { env-var } = dependency wscript.EnvVar
    { lcase, camelize } = dependency primitive.Str
    { value-as-string } = dependency primitive.Type
    { outln } = dependency wscript.Shell

    get-server = ->

      software: env-var 'server_software'
      name: env-var 'server_name'
      gateway-interface: env-var 'gateway_interface'

    get-request = ->

      server:

        protocol: env-var 'server_protocol'
        port: env-var 'server_port'

      method: env-var 'request_method'
      query: env-var 'query_string'
      script: env-var 'script_name'

      remote:

        host: env-var 'remote_host'
        addr: env-var 'remote_addr'
        ident: env-var 'remote_ident'

      content:

        type: env-var 'content_type'
        length: env-var 'content_length'

      http:

        accept: env-var 'http_accept'
        user-agent: env-var 'http_user_agent'
        cookie: env-var 'http_cookie'

    get-post-data = (method, content-type, content-length) ->

      return if (lcase method) isnt \post

      stdin = WScript.StdIn

      post-data = "#content-type #content-length "

      if not stdin.AtEndOfStream

        post-data += stdin.ReadAll!

      else

        post-data += 'at end of stream'

      post-data

    query-as-fieldset = (query = '') ->

      fieldset = {}

      names-and-values = query.split \&

      for pair in names-and-values

        if pair is ''
          continue

        [ name, value ] = pair.split \=

        name = camelize decodeURIComponent name
        value = decodeURIComponent value

        fieldset[ name ] = value

      fieldset

    handle-request = (handler) ->

      try

        request = get-request!

          query = query-as-fieldset ..query

          method = ..method

          ..content

            post-data = get-post-data method, ..type, ..length

        { content, headers } = handler query, request, get-server!, post-data

      catch error

        headers = [ "Content-Type: text/plain" ]

        content =

          * 'Error handling request'
            value-as-string error

      List headers ; List content

      lines = headers ++ [ "" ] ++ content

      for line in lines => outln line

    new-response-headers = ->

      list = []

      add = (name, value) -> list.push "#name: #value"

      content-type = (value) -> add 'Content-Type', value

      as-list = -> list

      { add, as-list, content-type }

    {
      handle-request,
      new-response-headers
    }

