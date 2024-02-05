
  do ->

    { new-namespace } = dependency wmi.Namespace
    { list-as-path-string } = dependency primitive.List
    { value-as-string } = dependency primitive.Type

    new-object-path = (class-name = '', server = '.', namespace = new-namespace!) ->

      to-string = ->

        class-string = ''

        if class-name isnt ''
          class-string = ":#class-name"

        namespace-string = namespace.to-string!

        namespace-string = "#namespace-string#class-string"

        list-as-path-string [ '', '', server, namespace-string ]

      { to-string }

    {
      new-object-path
    }