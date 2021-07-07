type rec t =
  | InvalidType
  | String(SchemaString.itemT)
  | Int(SchemaInt.itemT)
  | Float(float)
  | Boolean(SchemaBoolean.itemT)
  | Date(Js.Date.t)
  //
  | Option(SchemaOption.itemT)
  | Array(SchemaArray.itemT) // child schema
  | Dict(SchemaDict.itemT)

//
