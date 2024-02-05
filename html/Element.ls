
  do ->

    { new-element: new-xml-element } = dependency xml.Element
    { primitive-type-name, primitive-type-names: p } = dependency primitive.Type

    self-closing-element-names = <[ area base br col embed hr img input link meta source track wbr ]>

    is-self-closing-element = -> it in self-closing-element-names

    new-element = (tag-name, initial-attributes) ->

      element = new-xml-element tag-name, initial-attributes, is-self-closing-element tag-name

      inherited-add = element.add

      element.add = (tag-name, initial-attributes) -> inherited-add tag-name, initial-attributes, is-self-closing-element tag-name

      element.class = ->

        switch primitive-type-name it

          | p.Str  => element.attr class: it
          | p.List => element.attr class: it.join ' '

        element

      element

    #

    stylesheet = (href) -> new-element \link, rel: \stylesheet, href: href
    script = (src) -> new-element \script, src: src

    {
      new-element,
      stylesheet, script
    }
