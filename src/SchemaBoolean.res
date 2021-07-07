type itemT =
  | IsTrue
  | IsFalse
  | Function(string, bool => bool)

type t = array<itemT>

let validate = (schema: t, input: bool) => {
  let errorOpt = schema->Js.Array2.find(item => {
    switch item {
    | IsTrue if input != true => true
    | IsFalse if input != false => true
    | Function(_name, fn) if fn(input) == false => true
    | _ => false
    }
  })

  switch errorOpt {
  | None => Ok(input)
  | Some(error) => Error(error)
  }
}
