
  do ->

    { Str, FieldSet, Bool } = dependency primitive.Types
    { primitive-type-name, primitive-type-names: p, value-as-string: value } = dependency primitive.Type
    { map-list-items, list-as-string, word-list-as-string } = dependency primitive.List
    { angle-brackets: brackets, single-quotes, as-string, dasherize } = dependency primitive.Str
    { fieldset-as-list } = dependency primitive.FieldSet
    { debug } = dependency wscript.Debug

    children-as-string = -> it |> map-list-items _ , as-string |> list-as-string

    pair-as-string = (name, value) -> "#name=#{ single-quotes value }"

    dasherize-fieldset = (fieldset) -> { [ (dasherize name), value ] for name, value of fieldset }

    attributes-as-string = -> it |> dasherize-fieldset |> fieldset-as-list _ , pair-as-string |> word-list-as-string

    element-as-string = (tag-name, attributes, children, self-closing) ->

      children-string = children-as-string children
      attributes-string = attributes-as-string attributes

      if attributes-string isnt ''
        attributes-string = " #attributes-string"

      tag-and-attrs-string = "#tag-name#attributes-string"

      if self-closing

        brackets "#tag-and-attrs-string /"

      else

        opening = brackets tag-and-attrs-string
        closing = brackets "/#tag-name"

        "#opening#children-string#closing"

    new-element = (tag-name, initial-attributes = {}, self-closing = no) ->

      Str tag-name ; FieldSet initial-attributes ; Bool self-closing

      attributes = {}
      children = []

      #

      fn = ->

        debug value arguments

        switch primitive-type-name it

          | p.Void => to-string!

          | p.Str => add ...&

      #

      to-string = -> element-as-string tag-name, attributes, children, self-closing

      attr = -> FieldSet it ; for name, value of it => attributes[name] := value ; fn

      text = -> children.push Str it ; fn

      add = ->

        switch primitive-type-name it

          | p.Str => child = new-element ...& ; children.push child ; child
          | p.Fn  => children.push it! ; it

      #

      attr initial-attributes

      #

      fn <<< { to-string, attr, text, add }

      fn

    {
      new-element
    }
