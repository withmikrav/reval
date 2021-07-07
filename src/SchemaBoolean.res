type itemT =
  | IsTrue
  | IsFalse
  | Function(string, bool => bool)

type t = array<itemT>

let validate = (schema: t, input: bool) => {
  let errorOpt = schema->Js.Array2.find(item => {
    switch (item, input) {
    | (IsTrue, false) => true
    | (IsFalse, true) => true
    | (Function(_name, fn), input) if fn(input) == false => true
    | _ => false
    }
  })

  switch errorOpt {
  | None => Ok(input)
  | Some(error) => Error(error)
  }
}
