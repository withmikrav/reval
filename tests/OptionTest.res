Test.test("Option", () => {
  let validate = Schema.validate

  let schema = Schema.Option([IsSome], Schema.String([NotEmpty]))
  Assert.deepEqual(
    (
      schema->validate(Option(Some(String("Hello")))),
      schema->validate(Option(Some(String("")))),
      schema->validate(Option(None)),
      schema->validate(String("Hello")),
    ),
    (
      Ok(Option(Some(String("Hello")))),
      Error({
        path: None,
        error: String(NotEmpty),
      }),
      Error({
        path: None,
        error: Option(IsSome),
      }),
      Error({
        path: None,
        error: InvalidType,
      }),
    ),
    ~message="IsSome",
  )

  let schema = Schema.Option([IsNone], Schema.String([NotEmpty]))
  Assert.deepEqual(
    (
      schema->validate(Option(Some(String("Hello")))),
      schema->validate(Option(None)),
      schema->validate(String("Hello")),
    ),
    (
      Error({
        path: None,
        error: Option(IsNone),
      }),
      Ok(Option(None)),
      Error({
        path: None,
        error: InvalidType,
      }),
    ),
    ~message="IsNone",
  )

  let schema = Schema.Option(
    [Function("isNotNone", input => input != None)],
    Schema.String([NotEmpty]),
  )
  Assert.deepEqual(
    (schema->validate(Option(Some(String("Hello")))), schema->validate(Option(None))),
    (
      Ok(Option(Some(String("Hello")))),
      Error({
        path: None,
        error: Option(Function("isNotNone", i => i != None)),
      }),
    ),
    ~message="Function",
  )
})
