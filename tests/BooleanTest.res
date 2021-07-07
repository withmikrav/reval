Test.test("Reval.Boolean", () => {
  let validate = Schema.validate

  let schema = Schema.Boolean([IsTrue])
  Assert.deepEqual(
    ~message="IsTrue",
    (
      //
      schema->validate(Boolean(true)),
      schema->validate(Boolean(false)),
      schema->validate(Float(1.)),
    ),
    //
    (
      //
      Ok(Boolean(true)),
      Error({
        path: None,
        error: Boolean(IsTrue),
      }),
      Error({
        path: None,
        error: InvalidType,
      }),
    ),
  )

  let schema = Schema.Boolean([IsFalse])
  Assert.deepEqual(
    ~message="IsFalse",
    (
      //
      schema->validate(Boolean(true)),
      schema->validate(Boolean(false)),
      schema->validate(Float(1.)),
    ),
    //
    (
      //
      Error({
        path: None,
        error: Boolean(IsFalse),
      }),
      Ok(Boolean(true)),
      Error({
        path: None,
        error: InvalidType,
      }),
    ),
  )

  let schema = Schema.Boolean([Function("alwaysTrue", b => b == true)])
  Assert.deepEqual(
    ~message="Function",
    (
      //
      schema->validate(Boolean(true)),
      schema->validate(Boolean(false)),
    ),
    //
    (
      //
      Ok(Boolean(true)),
      Error({
        path: None,
        error: Boolean(Function("alwaysTrue", b => b == true)),
      }),
    ),
  )
})
