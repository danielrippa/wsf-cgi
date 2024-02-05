
  do ->

    new ActiveXObject 'htmlfile'
      ..write '<meta http-equiv="x-ua-compatible" content="IE=9" />'
      json = ..parent-window.JSON

    stringify = !-> try value = json.stringify it ; return value catch => throw new Error "unable to stringify json value"
    parse = !-> try value = json.parse it ; return value catch => throw new Error "unable to parse json value #it"

    {
      stringify,
      parse
    }