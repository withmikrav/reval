type rec t =
  //
  | String(SchemaString.errorT)
  | Int(SchemaInt.errorT)
  | Float(SchemaFloat.errorT)
  | Bool(SchemaBool.errorT)
  //
  | Option(SchemaOption.errorT)
  | Array(SchemaArray.errorT)
  | Dict(SchemaDict.errorT)
