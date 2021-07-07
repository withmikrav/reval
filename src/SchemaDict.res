type itemT =
  | RequiredKeys(array<string>)
  | Function(string, array<(string, Input.t)> => bool)

type t = array<itemT>

let toJsDict = input => Js.Dict.fromArray(input)

let validate = (schema: t, input: array<(string, Input.t)>) => {
  let dict = Js.Dict.fromArray(input)

  let firstError =
    schema
    ->Js.Array2.map(item => {
      switch item {
      | RequiredKeys(keys) =>
        let firstNoneKey = keys->Js.Array2.find(key => {
          dict->Js.Dict.get(key)->Js.Option.isNone
        })
        switch firstNoneKey {
        | None => None
        | Some(key) => Some(RequiredKeys([key]))
        }
      | Function(name, fn) =>
        if fn(input) {
          None
        } else {
          Some(Function(name, fn))
        }
      }
    })
    ->Js.Array2.find(opt => opt->Js.Option.isSome)

  switch firstError {
  | Some(Some(err)) => Error(err)
  | _ => Ok(input)
  }
}
