
  do ->

    { shell } = dependency wscript.Shell
    { new-tempfile: tempfile } = dependency wscript.TempFile
    { text-encoding } = dependency wscript.TextFile
    { double-quotes, affix } = dependency native.String
    { Str, MaybeStr, Num, Bool } = dependency primitive.Types
    { file-exists } = dependency wscript.FileSystem

    new-exec = -> shell!Exec it

      # https://www.vbsedit.com/html/f3358e96-3d5a-46c2-b43b-3107e586736e.asp
      # { ExitCode, ProcessID, Status, StdErr, StdIn, StdOut }

    new-rundll = (dll-name, function-name) -> new-exec "rundll32 #dll-name,#function-name"

    run = (command-line, working-folder, output-encoding = text-encoding.unicode, discard-output = yes) ->

      # Str command-line ; MaybeStr working-folder ; Num output-encoding ; Bool discard-output

      stdout = tempfile!
      stderr = tempfile!

      full-command-line = "#command-line > #{ stdout.filepath } 2> #{ stderr.filepath }"

      shell!

        ..CurrentDirectory = working-folder \
          unless working-folder is void

        status = ..Run full-command-line, 0, yes

      get-content = -> it.get-content discard-output

      output =

        stdout: get-content stdout
        stderr: get-content stderr

      { status, command-line, full-command-line } <<< output

    cmd = (command-line, working-folder, output-encoding, discard-output) ->

      comspec = affix \comspec, \%

      run "#comspec /c #command-line", working-folder, output-encoding, discard-output

    {
      run, cmd,
      new-exec, new-rundll
    }