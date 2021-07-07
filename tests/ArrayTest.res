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
      1,
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
        error: InvalidType,
      }),
      Error({
        path: None,
        error: InvalidType,
      }),
      1,
    ),
  )

  let stringSchema = Schema.String([NotEmpty])
  let childSchema = Schema.Array([MinLength(1)], stringSchema)
  let schema = Schema.Array([MinLength(1)], childSchema)

  Assert.deepEqual(
    (
      //
      schema->validate(
        Array([
          //
          Array([String("hello2"), String("")]),
          Array([String("sdfsd"), String("world2")]),
        ]),
      ),
      // schema->validate(Array([String("hello"), String("")])),
      1,
    ),
    //
    (
      //
      Error({
        path: Some("0.1"),
        error: String(NotEmpty),
      }),
      // Ok(Array([String("hello"), String("world")])),
      1,
    ),
    ~message="Nested",
  )
})
