type itemT =
  | NotEmpty
  | Length(int)
  | MinLength(int)
  | MaxLength(int)
  | MatchRegex(Js.Re.t)
  | Enum(array<string>)
  | Function(string, string => bool)
  | Trimmed

type t = array<itemT>

let validate = (schema: t, input: string) => {
  let value = ref(input)

  schema->Js.Array2.forEach(item => {
    switch item {
    | Trimmed if input !== "" => value := value.contents->String.trim
    | _ => ()
    }
  })

  let errorOpt = schema->Js.Array2.find(item => {
    switch item {
    | NotEmpty => input == ""
    | Length(int) => input->String.length !== int
    | MinLength(int) => input->String.length >= int == false
    | MaxLength(int) => input->String.length <= int == false
    | MatchRegex(re) => re->Js.Re.test_(input) == false
    | Function(_, fn) => fn(input) == false
    //
    | _ => false
    }
  })

  switch errorOpt {
  | None => Ok(value.contents)
  | Some(error) => Error(error)
  }
}
