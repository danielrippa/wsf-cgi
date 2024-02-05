
  do ->

    string-is-empty = (.length is 0)

    as-string = (.to-string!)

    circumfix = (stem, [ prefix = '', suffix = '' ]) -> "#prefix#stem#suffix"

    affix = (stem, adfix) -> circumfix stem, [ adfix, adfix ]

    square-brackets = -> circumfix it, <[ [ ] ]>
    angle-brackets  = -> circumfix it, <[ < > ]>

    single-quotes = -> affix it, \'
    double-quotes = -> affix it, \"

    parens = -> circumfix it, <[ ( ) ]>
    braces = -> circumfix it, <[ { } ]>

    words-regex = /\s+/

    string-to-word-array = (.split words-regex)

    string-as-word-array = (string) ->

      | string-is-empty string => []
      | otherwise => string-to-word-array string

    either-array-or-string-as-string = (value, separator = '') ->

      switch typeof! value

        | \String => value
        | \Array  => value.join separator

    first-char = (.0)
    last-char  = -> it.char-at it.length - 1

    drop-first = (string, n = 1) -> string.slice n
    drop-last = (string, n = 1) -> string.slice 0, -n

    {
      string-is-empty,
      as-string,
      circumfix, affix,
      square-brackets, angle-brackets,
      single-quotes, double-quotes,
      parens, braces,
      string-as-word-array,
      either-array-or-string-as-string,
      first-char, last-char,
      drop-first, drop-last
    }