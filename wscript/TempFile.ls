
  do ->

    { temporary-folder, file-system, file-exists, delete-file, build-path } = dependency wscript.FileSystem
    { get-content, set-content, add-content } = dependency wscript.TextFile
    { value-as-string } = dependency primitive.Type

    fs = file-system!

    new-tempfile = ->

      filepath = build-path temporary-folder!, fs.GetTempName!

      remove = -> if file-exists => delete-file filepath

      read = (discard = yes) ->

        if file-exists filepath

          { content } = get-content filepath

          remove! if discard

          content

      { filepath, remove, get-content: read }

    {
      new-tempfile
    }