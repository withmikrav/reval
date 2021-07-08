type inputT = option<Input.t>
type itemT =
  | IsSome
  | IsNone
  | Function(string, inputT => bool)
  //
  | Transform(inputT => inputT)

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
