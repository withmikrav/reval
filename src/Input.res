type rec t =
  | String(string)
  | Int(int)
  | Float(float)
  | Boolean(bool)
  | Date(Js.Date.t)
  | Array(array<t>)
  | Dict(Js.Dict.t<t>)
