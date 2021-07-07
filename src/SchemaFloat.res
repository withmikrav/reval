type itemT =
  | Equal(float)
  | GT(float)
  | GTE(float)
  | LT(float)
  | LTE(float)
  | Function(string, float => bool)

type t = array<itemT>

let validate = (schema: t, input: float) => {
  let value = ref(input)

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
  | None => Ok(value.contents)
  | Some(error) => Error(error)
  }
}
