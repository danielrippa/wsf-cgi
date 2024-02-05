
  do ->

    { Str, Num } = dependency primitive.Types

    file-system = -> new ActiveXObject \Scripting.FileSystemObject

    fs = file-system!

    base  = -> fs.GetBaseName Str it
    extension = -> fs.GetExtensionName Str it

    drive = -> fs.GetDriveName Str it

    absolute-path = -> fs.GetAbsolutePathName Str it

    #

    special-folder = -> fs.GetSpecialFolder Num it

    sf = special-folders = windows: 0, system: 1, temporary: 2

    windows-folder   = -> special-folder sf.windows
    system-folder    = -> special-folder sf.system
    temporary-folder = -> special-folder sf.temporary

    #

    try-fs = (fn) ->

      success = no

      try

        Fn fn fs
        success = yes

      catch error

      { success, error }

    delete-file   = (file)   -> try-fs (.DeleteFile   Str file)
    delete-folder = (folder) -> try-fs (.DeleteFolder Str file)

    file-exists   = -> fs.FileExists   Str it
    folder-exists = -> fs.FolderExists Str it

    build-path = (folder, file) -> fs.BuildPath folder, file

    as-file   = -> fs.GetFile Str it
    as-folder = -> fs.GetFolder Str it
    as-drive  = -> fs.GetDrive Str it

    # as-folder
    # https://learn.microsoft.com/en-us/office/vba/language/reference/user-interface-help/getfolder-method
    # Folder
    # https://learn.microsoft.com/en-us/office/vba/language/reference/user-interface-help/folder-object
    # Collections = { Files, SubFolders }
    # Methods = { Add, Copy, CreateTextFile, Delete, Mode }
    # Properties = { Attributes, DateCreated, DateLastAccessed, DateLastModified, Drive, Files, IsRootFolder, Name, ParentFolder, Path, ShortName, ShortPath, Size, SubFolders, Type }

    {
      file-system,
      base, extension, drive,
      absolute-path,
      windows-folder, system-folder, temporary-folder,
      build-path,
      delete-file, delete-folder,
      file-exists, folder-exists,
      as-file, as-folder, as-drive
    }
