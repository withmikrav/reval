type rec t =
  | String(string)
  | Int(int)
  | Float(float)
  | Boolean(bool)
  //
  | Option(option<t>)
  | Array(array<t>)
  | Dict(array<(string, t)>)
