type inputT = float
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
    | Equal(float) if input != float => true
    | GT(float) if input > float == false => true
    | GTE(float) if input >= float == false => true
    | LT(float) if input < float == false => true
    | LTE(float) if input <= float == false => true
    | Function(_name, fn) if fn(input) == false => true
    | _ => false
    }
  })

  switch errorOpt {
  | None => Ok(input)
  | Some(error) =>
    switch error {
    | Equal(float) => Equal(float)
    | GT(float) => GT(float)
    | GTE(float) => GTE(float)
    | LT(float) => LT(float)
    | LTE(float) => LTE(float)
    | Function(name, _) => Function(name)
    | _ => InvalidType
    }->Error
  }
}
