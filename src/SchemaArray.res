type itemT =
  | Length(int)
  | MinLength(int)
  | MaxLength(int)
  | Function(array<Input.t>, array<Input.t> => bool)

type t = array<itemT>

let validate = (schema: t, input: array<'input>) => {
  let errorOpt = schema->Js.Array2.find(item => {
    switch item {
    | Length(int) if input->Js.Array2.length == int => true
    | MinLength(int) if input->Js.Array2.length >= int == false => true
    | MaxLength(int) if input->Js.Array2.length <= int == false => true
    | Function(_, fn) if fn(input) == false => true
    | _ => false
    }
  })

  switch errorOpt {
  | None => Ok(input)
  | Some(error) => Error(error)
  }
}