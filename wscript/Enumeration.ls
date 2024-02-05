
  do ->

    id = -> it

    enumerate = (enumerable, fn = id) ->

      items = []

      new Enumerator enumerable

        loop

          break if ..at-end!

          item = fn ..item!

          items.push item

          ..move-next!

      items

    {
      enumerate
    }