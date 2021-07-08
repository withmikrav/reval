type itemT =
  | NotEmpty
  | Length(int)
  | MinLength(int)
  | MaxLength(int)
  | MatchRegex(Js.Re.t)
  | Enum(array<string>)
  | Function(string, string => bool)
  //
  | Transform(string => string)

type errorT =
  | NotEmpty
  | Length(int)
  | MinLength(int)
  | MaxLength(int)
  | MatchRegex(Js.Re.t)
  | Enum(array<string>)
  | Function(string)
  | InvalidType

type t = array<itemT>

let validate: (t, string) => result<string, errorT> = (schema, rawInput) => {
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
    | NotEmpty => input == ""
    | Length(int) => input->String.length !== int
    | MinLength(int) => input->String.length >= int == false
    | MaxLength(int) => input->String.length <= int == false
    | MatchRegex(re) => re->Js.Re.test_(input) == false
    | Enum(values) => values->Js.Array2.some(value => value == input) == false
    | Function(_, fn) => fn(input) == false
    //
    | _ => false
    }
  })

  switch errorOpt {
  | None => Ok(input)
  | Some(error) =>
    switch error {
    | NotEmpty => NotEmpty
    | Length(int) => Length(int)
    | MinLength(int) => MinLength(int)
    | MaxLength(int) => MaxLength(int)
    | MatchRegex(re) => MatchRegex(re)
    | Enum(arr) => Enum(arr)
    | Function(name, _) => Function(name)
    | _ => InvalidType
    }->Error
  }
}
