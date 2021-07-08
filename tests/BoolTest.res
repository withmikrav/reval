Test.test("Reval.Bool", () => {
  let validate = Schema.validate

  let schema = Schema.Bool([IsTrue])
  Assert.deepEqual(
    ~message="IsTrue",
    (
      //
      schema->validate(Bool(true)),
      schema->validate(Bool(false)),
      schema->validate(Float(1.)),
    ),
    //
    (
      //
      Ok(Bool(true)),
      Error({
        path: None,
        error: Bool(IsTrue),
      }),
      Error({
        path: None,
        error: Bool(InvalidType),
      }),
    ),
  )

  let schema = Schema.Bool([IsFalse])
  Assert.deepEqual(
    ~message="IsFalse",
    (
      //
      schema->validate(Bool(true)),
      schema->validate(Bool(false)),
      schema->validate(Float(1.)),
    ),
    //
    (
      //
      Error({
        path: None,
        error: Bool(IsFalse),
      }),
      Ok(Bool(false)),
      Error({
        path: None,
        error: Bool(InvalidType),
      }),
    ),
  )

  let schema = Schema.Bool([Function("alwaysTrue", b => b == true)])
  Assert.deepEqual(
    ~message="Function",
    (
      //
      schema->validate(Bool(true)),
      schema->validate(Bool(false)),
    ),
    //
    (
      //
      Ok(Bool(true)),
      Error({
        path: None,
        error: Bool(Function("alwaysTrue")),
      }),
    ),
  )

  let schema = Schema.Bool([Transform(b => !b)])
  Assert.deepEqual(
    ~message="Transform",
    (
      //
      schema->validate(Bool(true)),
      schema->validate(Bool(false)),
    ),
    //
    (
      //
      Ok(Bool(false)),
      Ok(Bool(true)),
    ),
  )
})
