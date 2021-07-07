type rec t =
  | InvalidType
  | String(SchemaString.itemT)
  | Int(SchemaInt.itemT)
  | Float(float)
  | Boolean(SchemaBoolean.itemT)
  | Date(Js.Date.t)
  | Array(SchemaArray.itemT) // child schema
  | Dict(Js.Dict.t<t>)
