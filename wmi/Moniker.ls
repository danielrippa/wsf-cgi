
  do ->

    { new-object-path } = dependency wmi.ObjectPath
    { new-security-settings } = dependency wmi.SecuritySettings

    wmi-scripting-api-prefix = \WinMgmts

    locale-as-string = -> if it isnt '' then "[locale=#locale]" else ''

    new-moniker = (object-path = new-object-path!, security-settings = new-security-settings!, locale = '') ->

      to-string = ->

        security-settings-string = security-settings.to-string!
        object-path-string = object-path.to-string!

        locale-string = if locale isnt ''
          locale-as-string locale
        else
          ''

        if security-settings-string isnt ''
          security-settings-string = "{#security-settings-string}"

        if locale-as-string isnt ''
          security-settings-string = "#security-settings-string#locale-string"

        if security-settings-string isnt ''
          if object-path-string isnt ''
            security-settings-string = "#{ security-settings-string }!#object-path-string"

        "#wmi-scripting-api-prefix:#security-settings-string"

      { to-string }

    {
      new-moniker
    }
