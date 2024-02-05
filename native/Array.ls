
  do ->

    is-empty-array = (.length is 0)

    array-as-object = (array) -> { [ name, name ] for name in array }

    word-array-as-string = (.join ' ')

    map-array-elements = (array, fn) -> [ (fn item, index, array) for item, index in array ]

    array-as-string = (string, separator = '') -> string.join separator

    array-as-spaced-csv-string = -> array-as-string it, ', '

    array-as-csv-string = -> array-as-string it, ','

    {
      is-empty-array,
      array-as-object,
      word-array-as-string,
      map-array-elements,
      array-as-string,
      array-as-csv-string, array-as-spaced-csv-string
    }
