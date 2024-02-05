
  do ->

    { Str, MaybeNum } = dependency primitive.Types
    { Either } = dependency primitive.Type

    # for exporting

    { string-is-empty: native-string-is-empty, as-string, circumfix, affix } = dependency native.String
    { square-brackets, angle-brackets, single-quotes, double-quotes, parens, braces } = dependency native.String
    { string-as-word-array, either-array-or-string-as-string } = dependency native.String
    { first-char: native-first-char, last-char: native-last-char } = dependency native.String
    { drop-first: native-drop-first, drop-last: native-drop-last }  = dependency native.String

    string-is-empty = -> native-string-is-empty Str it

    string-as-word-list = -> string-as-word-array Str it

    either-list-or-string-as-string = -> either-array-or-string-as-string Either <[ List Str ]> it

    first-char = -> native-first-char Str it
    last-char  = -> native-last-char  Str it

    drop-first = (str, n) -> Str str ; MaybeNum n ; native-drop-first str, n
    drop-last  = (str, n) -> Str str ; MaybeNum n ; native-drop-last str, n

    #

    string-as-fieldset = ->

    lcase = -> Str it ; it.to-lower-case!
    ucase = -> Str it ; it.to-upper-case!

    #

    camel = -> ucase &1 ? ''
    camel-regex = /[-_]+(.)?/g

    camelize = -> Str it ; it.replace camel-regex, camel

    #

    upper-lower-regex = /([^-A-Z])([A-Z]+)/g
    upper-regex = /^([A-Z]+)/

    dash-lower-upper = (, lower, upper) -> "#{ lower }-#{ if upper.length > 1 then upper else lcase upper }"
    dash-upper = (, upper) -> if upper.length > 1 then "#upper-" else lcase upper

    replace-upper-lower = (.replace upper-lower-regex, dash-lower-upper)
    replace-upper = (.replace upper-regex, dash-upper)

    dasherize = -> Str it |> replace-upper-lower |> replace-upper

    {
      Str,
      string-is-empty, as-string, circumfix, affix,
      square-brackets, angle-brackets, single-quotes, double-quotes, parens, braces,
      string-as-word-list, either-list-or-string-as-string,
      first-char, last-char,
      drop-first, drop-last,
      lcase, ucase,
      camelize, dasherize
    }