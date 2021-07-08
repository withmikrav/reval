type inputT = int
type itemT =
  | Equal(int)
  | GT(int)
  | GTE(int)
  | LT(int)
  | LTE(int)
  | Function(string, int => bool)
  //
  | Transform(inputT => inputT)

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
  | Some(error) => Error(error)
  }
}
