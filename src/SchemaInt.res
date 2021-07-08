type inputT = int
type itemT =
  | Equal(inputT)
  | GT(inputT)
  | GTE(inputT)
  | LT(inputT)
  | LTE(inputT)
  | Function(string, inputT => bool)
  //
  | Transform(inputT => inputT)

type errorT =
  | Equal(inputT)
  | GT(inputT)
  | GTE(inputT)
  | LT(inputT)
  | LTE(inputT)
  | Function(string)
  | InvalidType

type t = array<itemT>

let validate = (schema: t, rawInput: int) => {
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
    | Equal(int) if input != int => true
    | GT(int) if input > int == false => true
    | GTE(int) if input >= int == false => true
    | LT(int) if input < int == false => true
    | LTE(int) if input <= int == false => true
    | Function(_name, fn) if fn(input) == false => true
    | _ => false
    }
  })

  switch errorOpt {
  | None => Ok(input)
  | Some(error) =>
    switch error {
    | Equal(int) => Equal(int)
    | GT(int) => GT(int)
    | GTE(int) => GTE(int)
    | LT(int) => LT(int)
    | LTE(int) => LTE(int)
    | Function(name, _) => Function(name)
    | _ => InvalidType
    }->Error
  }
}
