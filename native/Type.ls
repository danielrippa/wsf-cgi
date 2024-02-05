
  do ->

    { array-as-object } = dependency native.Array

    native-type-name = (value) -> {} |> (.to-string) |> (.call value) |> (.slice 8, -1)

    native-type-names = array-as-object <[ String Object Number Array Arguments Boolean Function Undefined Error ]>

    {
      native-type-name,
      native-type-names
    }