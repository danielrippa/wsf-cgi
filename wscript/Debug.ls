
  do ->

    { run } = dependency wscript.Exec
    { value-as-string: value } = dependency primitive.Type

    debug = -> run "ods.cmd #{ value arguments }", "e:\\shared-tools"

    {
      debug
    }