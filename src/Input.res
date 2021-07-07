type rec t =
  | String(string)
  | Int(int)
  | Float(float)
  | Boolean(bool)
  | Date(Js.Date.t)
  //
  | Option(option<t>)
  | Array(array<t>)
  | Dict(array<(string, t)>)

let makeString = string => {
  String(string)
}

let makeInt = int => {
  String(int)
}
