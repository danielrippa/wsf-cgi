
  do ->

    { new-service } = dependency wmi.Service
    { list-as-fieldset } = dependency primitive.List

    # https://learn.microsoft.com/en-us/dotnet/framework/unmanaged-api/wmi/execquerywmi

    wmi-enumeration-options =

      use-amended-qualifiers: 0x2000
      return-immediately: 0x10
      forward-only: 0x20
      bidirectional: 0
      ensure-locatable: 0x100
      prototype: 2
      direct-read: 0x200

    wmi-enumeration-options => default-enumeration-options = ..return-immediately + ..forward-only

    query-languages = list-as-fieldset <[ WQL ]>

    wql = (query, service = new-service!, enumeration-options = default-enumeration-options) ->

      service.ExecQuery query, query-languages.WQL, enumeration-options

    {
      wql
    }