
  do ->

    { FieldSet, Fn } = dependency primitive.Types

    fieldset-as-list = (fieldset, fn) -> FieldSet fieldset ; Fn fn ; [ (fn name, value, fieldset) for name, value of fieldset ]

    {
      FieldSet,
      fieldset-as-list
    }
