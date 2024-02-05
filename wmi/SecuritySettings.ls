
  do ->

    { list-as-csv-string, list-as-fieldset, is-empty-list } = dependency primitive.List
    { Str, parens, braces } = dependency primitive.Str
    { List } = dependency primitive.Types

    # WMI Security Settings
    # https://learn.microsoft.com/en-us/previous-versions/tn-archive/ee156574(v=technet.10)

    # Both Impersonation Level and Authentication Level are not specific to WMI but rather are derived from DCOM
    # which WMI uses to access the WMI infrastructure on remote computers

    # In the context of WMI impersonation governs the degree to which a script will allow a remote WMI service
    # to carry out tasks on someones behalf.

    #

    # 'Anonymous' impersonation hides your credentials and 'Identify' permits a remote object to query your
    # credentials, but the remote object cannot impersonate your security context. In other words, although
    # the remote object knows who you are, it cannot 'pretend' to be you.
    # WMI scripts accessing remote computers using one of these two settings will generally fail. In fact,
    # most scripts run on the local computer using one of these two settings will also fail.
    # 'Impersonate' permits the remote WMI service to use your security context to perform the requested operation.
    # A remote WMI request that uses the Impersonate setting typically succeeds, provided your credentials have
    # sufficient privileges to perform the intended operation. In other words, you cannot use WMI to perform an
    # action (remotely or otherwise) that you do not have permission to perform outside WMI.
    # Setting impersonationLevel to Delegate permits the remote WMI service to pass your credentials on to other
    # objects and is generally considered a security risk.

    # WMI versions prior to version 1.5 use Identify as the default impersonationLevel setting. This forces WMI
    # scripts that connect to remote computers to include impersonationLevel=Impersonate as part of any moniker string.
    # With the release of WMI version 1.5 in Windows 2000, Microsoft changed the default impersonationLevel setting
    # to Impersonate. By ommitting impersonationLevel=Impersonate, scripts accessing computers with an earlier release
    # of WMI will fail. For backward and potentially forward compatibility, you should always explicitly set
    # impersonationLevel.

    impersonation-level-names = <[ Anonymous Identify Impersonate Delegate ]>

    impersonation-levels = list-as-fieldset impersonation-level-names

    ImpersonationLevel = -> Str it ; throw new Error "Invalid impersonation level #it" unless it in impersonation-level-names

    #

    # The authenticationLevel setting enables to request the level of DCOM authentication and privacy to be used
    # throughout a connection. Settings range from no authentication to per-packet encrypted authentication.
    # Specifying an authenticationLevel is more of a request than a command because there is no guarantee that the
    # setting will be honored. For example, local connections always use authenticationLevel=PktPrivacy

    authentication-level-names = <[ None Default Connect Call Pkt PktIntegrity PktPrivacy ]>

    authentication-levels = list-as-fieldset authentication-level-names

    AuthenticationLevel = -> Str it ; throw new Error "Invalid authentication level #it" unless it in authentication-level-names

    #

    privilege-names = <[

      CreateToken
      AssignPrimaryToken
      LockMemory
      IncreaseQuota
      MachineAccount
      Tcb
      Security
      TakeOwnership
      LoadDriver
      SystemProfile
      SystemTime
      ProfileSingleProcess
      IncreaseBasePriority
      CreatePagefile
      CreatePermanent
      Backup
      Restore
      Shutdown
      Debug
      Audit
      SystemEnvironment
      ChangeNotify
      RemoteShutdown
      Undock
      SyncAgent
      EnableDelegation

    ]>

    privileges = list-as-fieldset privilege-names

    Privilege = -> Str it ; throw new Error "Invalid privilege name" unless it in privilege-names

    #

    new-security-settings = (impersonation-level = impersonation-levels.Impersonate, authentication-level = authentication-levels.PktPrivacy, privilege-overrides = []) ->

      ImpersonationLevel impersonation-level ; AuthenticationLevel authentication-level ; List privilege-overrides

      if not is-empty-list privilege-overrides

        for privilege in privilege-overrides

          if (first-char privilege) is '!'
            privilege = drop-first privilege

          Privilege privilege

      #

      grant  = (privilege) -> Privilege privilege ; privilege-overrides.push privilege
      revoke = (privilege) -> Privilege privilege ; privilege-overrides.push "!#privilege"

      to-string = ->

        security-settings = [ "impersonationLevel=#impersonation-level" ]

        # TODO:
        # if authentication-level isnt ''
        #  security-settings.push "authenticationLevel=#authentication-level"

        privileges-string = list-as-csv-string privilege-overrides

        if privileges-string isnt ''
          security-settings.push parens privileges-string

        list-as-csv-string security-settings

      { grant, revoke, to-string }

    {
      new-security-settings,
      impersonation-levels, authentication-levels, privileges
    }
