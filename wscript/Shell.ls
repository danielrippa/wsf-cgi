
  do ->

    { primitive-type-name, primitive-type-names: p } = dependency primitive.Type
    { base } = dependency wscript.FileSystem

    shell = -> new ActiveXObject \WScript.Shell

    [ out, err ] = do ->

      stream = (name) -> !-> for arg in arguments => WScript["Std#name"].Write arg

      [ (stream name) for name in <[ Out Err ]> ]

    nl = '\n'

    lnout = -> out nl ; out ...&
    outln = -> out ...& ; out nl

    lnerr = -> err nl ; err ...&
    errln = -> err ...& ; err nl

    stdin = -> WScript.StdIn.ReadAll!

    exit = (errorlevel = 0) -> WScript.Quit errorlevel

    fail = (message, errorlevel = 1) ->

      switch primitive-type-name message

        | p.Str => err message
        | p.List => for line in message => err line

      exit errorlevel

    script-name = base WScript.ScriptName

    {
      shell,
      out, lnout, outln,
      err, lnerr, errln,
      stdin,
      exit, fail,
      script-name
    }
