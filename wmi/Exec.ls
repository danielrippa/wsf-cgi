
  do ->

    { new-tempfile: tempfile } = dependency wscript.TempFile
    { new-service } = dependency wmi.Service
    { new-moniker } = dependency wmi.Moniker
    { new-object-path } = dependency wmi.ObjectPath

    run = (command-line, working-folder) ->

      stdout = tempfile!
      stderr = tempfile!

      full-command-line = "#command-line > #{ stdout.filepath } 2> #{ stderr.filepath }"

      process-startup = new-service!.Get \Win32_ProcessStartup

      instance = process-startup.SpawnInstance_!

      object-path = new-object-path 'Win32_Process'

      moniker = new-moniker object-path.to-string!

      automation-id = moniker.to-string!

      process = GetObject automation-id

      process-id = void

      status = process.Create full-command-line,, instance, process-id

      { process, process-id, status, stdout, stderr }

    {
      run
    }