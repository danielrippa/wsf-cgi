
  do ->

    { new-moniker } = dependency wmi.Moniker

    new-service = (moniker = new-moniker!) ->

      automation-id = moniker.to-string!

      GetObject automation-id

    {
      new-service
    }