type itemT =
  | IsSome
  | IsNone
  | Function(string, option<Input.t> => bool)

type t = array<itemT>

let validate = (schema: t, input: option<Input.t>) => {
  let errorOpt = schema->Js.Array2.find(item => {
    switch (item, input) {
    | (IsSome, None) => true
    | (IsNone, Some(_)) => true
    | (Function(_name, fn), input) if fn(input) == false => true
    | _ => false
    }
  })

  switch errorOpt {
  | None => Ok(input)
  | Some(error) => Error(error)
  }
}
