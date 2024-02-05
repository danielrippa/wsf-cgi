
  do ->

    { List: PrimitiveList, Fn, MaybeStr } = dependency primitive.Types
    { must-be, list-items-type-descriptor } = dependency primitive.Type
    { either-array-or-string-as-string, last-char, drop-last } = dependency native.String

    # for exporting

    { is-empty-array, array-as-object, word-array-as-string, map-array-elements } = dependency native.Array
    { array-as-string, array-as-csv-string, array-as-spaced-csv-string } = dependency native.Array

    list-type = (items-type) -> "List <[ #items-type ]>"

    text-as-string = -> either-array-or-string-as-string it, ' '

    List = (items-type-descriptor, value) ->

      PrimitiveList value

      items-type = text-as-string items-type-descriptor

      actual-items-type = list-items-type-descriptor value

      is-optional = (last-char items-type) is '?'

      if is-optional

        items-type = drop-last items-type

        switch actual-items-type

          | \* =>
          | items-type =>

          else value `must-be` "a #{ list-type items-type }"

      else

        value `must-be` "a #{ list-type items-type }" \
          unless actual-items-type is items-type

      value

    # exporting native.Array functions

    is-empty-list = (list) -> PrimitiveList list ; is-empty-array list

    list-as-string = (list, separator) -> PrimitiveList list ; MaybeStr separator ; array-as-string list, separator

    list-as-fieldset = (list) -> array-as-object PrimitiveList list

    word-list-as-string = (word-list) -> word-array-as-string PrimitiveList word-list

    map-list-items = (list, fn) -> PrimitiveList list ; Fn fn ; map-array-elements list, fn

    list-as-csv-string = -> array-as-csv-string PrimitiveList it
    list-as-spaced-csv-string = -> array-as-spaced-csv-string PrimitiveList it

    #

    list-as-path-string = -> list-as-string it, '\\'

    first-item = (list) -> PrimitiveList list ; list.0
    last-item  = (list) -> PrimitiveList list ; list[ list.length - 1 ]

    {
      List,
      is-empty-list,
      list-as-fieldset,
      word-list-as-string,
      map-list-items,
      list-as-csv-string, list-as-spaced-csv-string,
      list-as-string,
      list-as-path-string,
      first-item, last-item
    }