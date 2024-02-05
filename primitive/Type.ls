
  do ->

    { array-as-object, word-array-as-string, is-empty-array, map-array-elements, array-as-spaced-csv-string } = dependency native.Array
    { native-type-name, native-type-names: n } = dependency native.Type
    { affix, square-brackets, angle-brackets, single-quotes, parens, braces, string-as-word-array, either-array-or-string-as-string } = dependency native.String

    p = primitive-type-names = array-as-object <[ Str Null FieldSet Num NaN List Bool Fn Void Tuple Exception ]>

    primitive-type-name = (value) ->

      switch native-type-name value

        | n.String => p.Str
        | n.Object, n.Error =>

          switch value

            | null => p.Null
            | void => p.Void

            else p.FieldSet

        | n.Array, n.Arguments => p.List
        | n.Boolean => p.Bool
        | n.Number => p.Num
        | n.Function => p.Fn
        | n.Undefined => p.Void

        else that

    container-type-name = (container) ->

      type = void

      for value in container

        if type is void

          type = primitive-type-name value

        if type isnt primitive-type-name value
          return p.Tuple

      p.List

    text = -> either-array-or-string-as-string it, ' '

    space-affix = (value = '') -> affix value, if value is '' then '' else ' '

    type-brackets = -> it |> space-affix |> square-brackets |> angle-brackets

    list-items-type-descriptor = (items) ->

      | is-empty-array items => \*
      | otherwise => primitive-type-name items.0

    elements-as-type-descriptors = (elements) -> map-array-elements elements, type-descriptor

    tuple-elements-type-descriptor = (elements) ->

      elements |> elements-as-type-descriptors |> array-as-spaced-csv-string

    container-type-descriptor = (type, values) ->

      container-type = container-type-name values

      values-type-descriptor = switch container-type

        | p.List => list-items-type-descriptor values
        | p.Tuple => tuple-elements-type-descriptor values

      "#container-type #{ type-brackets values-type-descriptor }"

    member-as-type-descriptor = (name, value) -> "#name: #{ type-descriptor value }"

    members-as-type-descriptors = -> map-array-elements it, member-as-type-descriptor

    fieldset-type-descriptor = (type, fieldset) ->

      "#type#{ fieldset |> members-as-type-descriptors |> array-as-spaced-csv-string }"

    type-descriptor = (value) ->

      switch primitive-type-name value

        | p.List => container-type-descriptor that, value
        | p.FieldSet => fieldset-type-descriptor that, value

        else that

    quoted-if-string = (value) ->

      switch primitive-type-name value

        | p.Str => single-quotes value
        | otherwise => String value

    array-as-string = (array) -> array |> map-array-elements _ , quoted-if-string |> array-as-spaced-csv-string |> space-affix

    container-as-string = (container) ->

      switch container-type-name container

        | p.List => square-brackets container
        | p.Tuple => parens array-as-string container

    member-as-string = (name, value) -> "#name: #{ value-as-string value }"

    fieldset-as-string = (fieldset) ->

      members = []

      for name, value of fieldset => members.push member-as-string name, value

      members |> array-as-spaced-csv-string |> space-affix |> braces

    value-as-string = (value) ->

      switch primitive-type-name value

        | p.List => container-as-string value
        | p.FieldSet => fieldset-as-string value

        else quoted-if-string value

    must-be = (value, message) ->

      throw new Error "Value #{ type-descriptor value } #{ value-as-string value } must be #message"

    Type = (descriptor, value) ->

      type = text descriptor

      value `must-be` "of type #{ type-brackets type }" \
        unless type is primitive-type-name value

      value

    Either = (types-descriptor, value) ->

      types = types-descriptor |> text |> string-as-word-array

      value-type = primitive-type-name value

      actual-type = void

      for type in types

        if type is value-type

          actual-type = type
          break

      value `must-be` "any of #{ array-as-spaced-csv-string types }" \
        unless actual-type isnt void

      value

    Maybe = (descriptor, value) -> Either [ descriptor, p.Void ] value

    {
      primitive-type-name, primitive-type-names,
      must-be, type-brackets,
      value-as-string, type-descriptor,
      list-items-type-descriptor, tuple-elements-type-descriptor,
      Type, Either, Maybe
    }
