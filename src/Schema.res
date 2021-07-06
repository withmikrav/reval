module Input = Input

module String = SchemaString
module Int = SchemaInt
module Array = SchemaArray

type rec errorItemT =
  | InvalidType
  | String(String.itemT)
  | Int(Int.itemT)
  | Float(float)
  | Boolean(bool)
  | Date(Js.Date.t)
  | Array(Array.itemT) // child schema
  | Dict(Js.Dict.t<errorItemT>)

type rec t =
  | String(String.t)
  | Int(Int.t)
  | Float(float)
  | Boolean(bool)
  | Date(Js.Date.t)
  | Array(Array.t, t) // child schema
  | Dict(Js.Dict.t<t>)

type errorT = {
  path: option<string>,
  error: errorItemT,
}

let rec validate = (~path=None, schema: t, input: Input.t): result<Input.t, errorT> => {
  switch (schema, input) {
  | (String(schema), String(input)) =>
    let res = String.validate(schema, input)
    switch res {
    | Ok(value) => Ok(String(value))
    | Error(errors) =>
      Error({
        path: path,
        error: String(errors),
      })
    }
  | (Int(schema), Int(input)) =>
    let res = Int.validate(schema, input)
    switch res {
    | Ok(value) => Ok(Int(value))
    | Error(errors) =>
      Error({
        path: path,
        error: Int(errors),
      })
    }
  | (Array(schema, childSchema), Array(input)) =>
    let res = Array.validate(schema, input)
    switch res {
    | Ok(values) => {
        // Js.log(path->Belt.Option.getWithDefault("0"))
        let firstError =
          values
          ->Js.Array2.mapi((value, idx) => {
            let idxString = idx->string_of_int
            let currPath = switch path {
            | None => Some(idxString)
            | Some(str) => Some(str ++ "." ++ idxString)
            }
            childSchema->validate(value, ~path=currPath)
          })
          ->Js.Array2.find(item => {
            switch item {
            | Error(_) => true
            | Ok(_) => false
            }
          })

        switch firstError {
        | Some(Error(err)) =>
          Error({
            path: err.path,
            error: err.error,
          })
        | _ => Ok(Array(values))
        }
      }

    | Error(errors) =>
      Error({
        path: path,
        error: Array(errors),
      })
    }

  | _ =>
    Error({
      {
        path: path,
        error: InvalidType,
      }
    })
  }
}
