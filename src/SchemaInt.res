type itemT =
  | Equal(int)
  | GT(int)
  | GTE(int)
  | LT(int)
  | LTE(int)
  | Function(int, int => bool)

type t = array<itemT>

let validate = (schema: t, input: int) => {
  let value = ref(input)

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
  | None => Ok(value.contents)
  | Some(error) => Error(error)
  }
}
