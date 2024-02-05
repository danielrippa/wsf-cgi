
  do ->

    { Type, Maybe, Either } = dependency primitive.Type

    Str = -> Type <[ Str ]> it
    MaybeStr = -> Maybe <[ Str ]> it

    Num = -> Type <[ Num ]> it
    MaybeNum = -> Maybe <[ Num ]> it

    FieldSet = -> Type <[ FieldSet ]> it
    MaybeFieldSet = -> Maybe <[ FieldSet ]> it

    Fn = -> Type <[ Fn ]> it
    MaybeFn = -> Maybe <[ Fn ]> it

    Bool = -> Type <[ Bool ]> it
    MaybeBool = -> Maybe <[ Bool ]> it

    List = -> Type <[ List ]> it
    MaybeList = -> Maybe <[ List ]> it

    {
      Type, Maybe, Either,
      Str, MaybeStr,
      Num, MaybeNum,
      FieldSet, MaybeFieldSet,
      Fn, MaybeFn,
      Bool, MaybeBool,
      List, MaybeList
    }