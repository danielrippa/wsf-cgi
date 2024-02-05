
  do ->

    { shell } = dependency wscript.Shell
    { affix } = dependency primitive.Str

    expand = -> shell!ExpandEnvironmentStrings it

    as-environment-var = -> affix it, \%

    env-var = -> query = as-environment-var it ; value = expand query ; if value is query then '' else value

    {
      env-var
    }
