type rec t =
  | String(SchemaString.t)
  | Int(SchemaInt.t)
  | Float(SchemaFloat.t)
  | Boolean(SchemaBoolean.t)
  //
  | Option(SchemaOption.t, t)
  | Array(SchemaArray.t, t) // array schema, child schema
  | Dict(SchemaDict.t, array<(string, t)>) // dict schema, { key: schema }

type errorT = {
  path: option<string>,
  error: Error.t,
}

let rec validate = (~path=None, schema: t, input: Input.t): result<Input.t, errorT> => {
  switch (schema, input) {
  | (String(schema), String(input)) =>
    let res = SchemaString.validate(schema, input)
    switch res {
    | Ok(value) => Ok(String(value))
    | Error(errors) =>
      Error({
        path: path,
        error: String(errors),
      })
    }
  | (Boolean(schema), Boolean(input)) =>
    let res = SchemaBoolean.validate(schema, input)
    switch res {
    | Ok(value) => Ok(Boolean(value))
    | Error(errors) =>
      Error({
        path: path,
        error: Boolean(errors),
      })
    }
  | (Int(schema), Int(input)) =>
    let res = SchemaInt.validate(schema, input)
    switch res {
    | Ok(value) => Ok(Int(value))
    | Error(errors) =>
      Error({
        path: path,
        error: Int(errors),
      })
    }
  | (Float(schema), Float(input)) =>
    let res = SchemaFloat.validate(schema, input)
    switch res {
    | Ok(value) => Ok(Float(value))
    | Error(errors) =>
      Error({
        path: path,
        error: Float(errors),
      })
    }
  | (Option(optionSchema, childSchema), Option(input)) => {
      let res = SchemaOption.validate(optionSchema, input)
      switch res {
      | Ok(None) => Ok(Option(None))
      | Ok(Some(value)) => {
          let res = childSchema->validate(value, ~path)
          switch res {
          | Ok(value) => Ok(Option(Some(value)))
          | Error(err) => Error(err)
          }
        }
      | Error(err) =>
        Error({
          path: path,
          error: Option(err),
        })
      }
    }

  | (Array(schema, childSchema), Array(input)) =>
    let res = SchemaArray.validate(schema, input)
    switch res {
    | Ok(values) => {
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
        | Some(Ok(values)) => Ok(values)
        | None => Ok(Array(values))
        }
      }

    | Error(errors) =>
      Error({
        path: path,
        error: Array(errors),
      })
    }
  | (Dict(dictSchema, dictChildSchema), Dict(input)) => {
      let res = SchemaDict.validate(dictSchema, input)
      switch res {
      | Ok(values) => {
          let inputDict = Js.Dict.fromArray(input)

          let firstError =
            dictChildSchema
            ->Js.Array2.map(((key, keySchema)) => {
              let value = inputDict->Js.Dict.unsafeGet(key)
              let currPath = switch path {
              | None => Some(key)
              | Some(str) => Some(str ++ "." ++ key)
              }
              keySchema->validate(value, ~path=currPath)
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
          | Some(Ok(values)) => Ok(values)
          | None => Ok(Dict(values))
          }
        }

      | Error(errors) =>
        Error({
          path: path,
          error: Dict(errors),
        })
      }
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
