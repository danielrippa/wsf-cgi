
  do ->

    { instances-where, instance-where } = dependency wmi.Query
    { new-rundll } = dependency wscript.Shell
    { new-tempfile: tempfile } = dependency wscript.TempFile
    { new-object-path } = dependency wmi.ObjectPath

    process-class = \Win32_Process

    # Properties
    # https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-process
    # { CreationClassName, Caption, CommandLine, CreationDate, CDCreationClassName, CSName, Description, ExecutablePath, ExecutionState }
    # { Handle, HandleCount, InstallDate, KernelModeTime, MaximumWorkingSetSize, MinimumWorkingSetSize, Name, OSCreationClassName, OSName }
    # { OtherOperationCount, OtherTransferCount, PageFaults, PageFileUsage, ParentProcessId, PeakPageFileUsage, PeakVirtualSize, PeakWorkingSetSize }
    # { Priority, PrivatePageCount, ProcessId, QuotaNonPagedPoolUsage, QuotaPagedPoolUsage, QuotaPeakNonPagedPoolUsage, QuotaPeakPagedPoolUsage }
    # { ReadOperationCount, ReadTransferCount, SessionId, Status, TerminationDate, ThreadCount, UserModeTime, VirtualSize, WindowsVersion }
    # { WorkingSetSize, WriteOperationCount, WriteTransferCount }

    # Methods
    # https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-process-methods
    # { AttachDebugger, Create, GetAvailableVirtualSize, GetOwner, GetOwnerSid, SetPriority, Terminate }

    processes-where = (predicate) -> instances-where process-class, predicate

    process-where = (predicate) -> instance-where process-class, predicate

    processes-named = (name) -> processes-where "name = '#name'"

    process-named = (name) -> process-where "name = '#name'"

    current-process-id = ->

      sleep-process = new-rundll \kernel32 \Sleep

      process-where "HANDLE = #{ sleep-process.ProcessId }"

        process-id = ..ParentProcessId

      sleep-process.Terminate!

      process-id

    current-process = -> process-where "HANDLE = #{ current-process-id! }"

    {
      process-where, processes-where,
      processes-named, process-named,
      current-process
    }