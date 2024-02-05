
  do ->

    { new-service } = dependency wmi.Service
    { wql } = dependency wmi.Wql
    { list-as-csv-string } = dependency primitive.Str
    { enumerate } = dependency wscript.Enumeration
    { is-empty-list, first-item } = dependency primitive.List

    field-list = -> if it is void then '*' else list-as-csv-string it

    predicate = -> if it is void then '' else "WHERE #it"

    select = (class-name, condition, fields, service = new-service!) ->

      wql "SELECT #{ field-list fields } FROM #class-name #{ predicate condition }", service

    instances-where = (class-name, condition, fields, service, fn) ->

      enumerate (select class-name, condition, fields, service), fn

    instance-where = (class-name, condition, fields, service, fn) ->

      instances = instances-where class-name, condition, fields, service, fn

      if not is-empty-list instances
        first-item instances

    {
      select,
      instances-where, instance-where
    }