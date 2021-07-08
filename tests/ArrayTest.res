Test.test("Reval.Array", () => {
  let validate = Schema.validate

  let childSchema = Schema.String([MinLength(2)])
  let schema = Schema.Array([MinLength(2)], childSchema)

  Assert.deepEqual(
    ~message="MinLength",
    (
      //
      schema->validate(Array([String("hello"), String("world")])),
      schema->validate(Array([String("hello"), String("")])),
      schema->validate(Array([String("hello")])),
      schema->validate(Array([Int(0), Int(2)])),
      schema->validate(String("")),
    ),
    //
    (
      //
      Ok(Array([String("hello"), String("world")])),
      Error({
        path: Some("1"),
        error: String(MinLength(2)),
      }),
      Error({
        path: None,
        error: Array(MinLength(2)),
      }),
      Error({
        path: Some("0"),
        error: String(InvalidType),
      }),
      Error({
        path: None,
        error: Array(InvalidType),
      }),
    ),
  )

  let childSchema = Schema.String([])
  let schema = Schema.Array([MaxLength(2)], childSchema)
  Assert.deepEqual(
    ~message="MaxLength",
    (
      //
      schema->validate(Array([String("hello"), String("world")])),
      schema->validate(Array([String("hello"), String(""), String("")])),
    ),
    //
    (
      //
      Ok(Array([String("hello"), String("world")])),
      Error({
        path: None,
        error: Array(MaxLength(2)),
      }),
    ),
  )

  let childSchema = Schema.String([])
  let schema = Schema.Array([Length(2)], childSchema)
  Assert.deepEqual(
    ~message="Length",
    (
      //
      schema->validate(Array([String("hello"), String("world")])),
      schema->validate(Array([String("hello"), String(""), String("")])),
    ),
    //
    (
      //
      Ok(Array([String("hello"), String("world")])),
      Error({
        path: None,
        error: Array(Length(2)),
      }),
    ),
  )

  let childSchema = Schema.String([])
  let schema = Schema.Array(
    [Function("lengthIsNot2", arr => arr->Js.Array2.length != 2)],
    childSchema,
  )
  Assert.deepEqual(
    ~message="Function",
    (
      //
      schema->validate(Array([String("hello"), String("world")])),
      schema->validate(Array([String("hello")])),
      schema->validate(Array([String(""), String(""), String("")])),
    ),
    //
    (
      //
      Error({
        path: None,
        error: Array(Function("lengthIsNot2")),
      }),
      Ok(Array([String("hello")])),
      Ok(Array([String(""), String(""), String("")])),
    ),
  )

  let childSchema = Schema.String([MinLength(2)])
  let schema = Schema.Array(
    [Transform(arr => arr->Js.Array2.filter(item => item == String("hello")))],
    childSchema,
  )
  Assert.deepEqual(
    ~message="Transform",
    (
      //
      schema->validate(Array([String("hello"), String("world")])),
      schema->validate(Array([String("hello"), String(""), String("")])),
    ),
    //
    (
      //
      Ok(Array([String("hello")])),
      Ok(Array([String("hello")])),
    ),
  )

  let stringSchema = Schema.String([NotEmpty])
  let childSchema = Schema.Array([MinLength(1)], stringSchema)
  let schema = Schema.Array([MinLength(1)], childSchema)

  Assert.deepEqual(
    //
    ~message="Nested",
    schema->validate(
      Array([
        //
        Array([String("hello2"), String("")]),
        Array([String("sdfsd"), String("world2")]),
      ]),
    ),
    //
    Error({
      path: Some("0.1"),
      error: String(NotEmpty),
    }),
  )
})
