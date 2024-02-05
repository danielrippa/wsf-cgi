
  do ->

    { list-as-path-string } = dependency primitive.List

    new-namespace = (path = <[ root CIMv2 ]>) ->

      to-string: -> list-as-path-string path

    {
      new-namespace
    }
