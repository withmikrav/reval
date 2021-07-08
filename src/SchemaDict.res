type inputT = array<(string, Input.t)>

type itemT =
  | RequiredKeys(array<string>)
  | Function(string, inputT => bool)
  //
  | Transform(inputT => inputT)

type errorT = RequiredKeys(array<string>) | Function(string) | InvalidType
type t = array<itemT>

let validate = (schema: t, rawInput: inputT) => {
  let value = ref(rawInput)

  schema->Js.Array2.forEach(item => {
    switch item {
    | Transform(fn) => value := value.contents->fn
    | _ => ()
    }
  })

  let input = value.contents

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
          Some(Function(name))
        }
      | _ => None
      }
    })
    ->Js.Array2.find(opt => opt->Js.Option.isSome)

  switch firstError {
  | Some(Some(err)) => Error(err)
  | _ => Ok(input)
  }
}
