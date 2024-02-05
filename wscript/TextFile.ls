
  do ->

    { file-system } = dependency wscript.FileSystem

    fs = file-system!

    io-mode = reading: 1, writing: 2, appending: 8

    text-encoding = system-default: -2, unicode: -1, ascii: 0

    text-stream = (filepath, mode, create = no, encoding = text-enconding.ascii) ->

      fs.OpenTextFile filepath, mode, create, encoding

    consume-stream = (stream, fn) ->

      success = no

      try

        content = fn stream
        stream.Close!

        success = yes

      catch error

      { content, success, error }

    appending-or-writing = -> io-mode => return if it then ..appending else ..writing

    readable  = (filepath, encoding)       -> text-stream filepath,  io-mode.reading,            no,  encoding
    writeable = (filepath, encoding, mode) -> text-stream filepath, (appending-or-writing mode), yes, encoding

    get-content = (filepath, encoding = text-encoding.ascii) -> consume-stream (readable filepath, encoding), (.ReadAll!)
    set-content = (filepath, content, encoding = text-encoding.ascii, appending = no) -> consume-stream (writeable filepath, encoding, appending), (.Write content)
    add-content = (filepath, content, encoding = text-encoding.ascii) -> set-content filepath, content, encoding, yes

    {
      text-encoding,
      get-content, set-content, add-content
    }