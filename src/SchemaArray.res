type inputT = array<Input.t>
type itemT =
  | Length(int)
  | MinLength(int)
  | MaxLength(int)
  | Function(string, inputT => bool)
  | Transform(inputT => inputT)

type errorT =
  | Length(int)
  | MinLength(int)
  | MaxLength(int)
  | Function(string)
  | InvalidType

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

  let errorOpt = schema->Js.Array2.find(item => {
    switch item {
    | Length(int) if (input->Js.Array2.length == int) == false => true
    | MinLength(int) if input->Js.Array2.length >= int == false => true
    | MaxLength(int) if input->Js.Array2.length <= int == false => true
    | Function(_, fn) if fn(input) == false => true
    | _ => false
    }
  })

  switch errorOpt {
  | None => Ok(input)
  | Some(error) =>
    switch error {
    | Length(int) => Length(int)
    | MinLength(int) => MinLength(int)
    | MaxLength(int) => MaxLength(int)
    | Function(name, _) => Function(name)
    | _ => InvalidType
    }->Error
  }
}
