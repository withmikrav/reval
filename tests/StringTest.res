Test.test("Reval.String", () => {
  let validate = Schema.validate

  let schemaRequired = Schema.String([NotEmpty])
  Assert.deepEqual(
    (
      //
      schemaRequired->validate(String("hello")),
      schemaRequired->validate(String("")),
    ),
    //
    (
      //
      Ok(String("hello")),
      Error({
        path: None,
        error: String(NotEmpty),
      }),
    ),
    ~message="NotEmpty",
  )

  let schemaMinLength = Schema.String([MinLength(4)])
  Assert.deepEqual(
    (
      //
      schemaMinLength->validate(String("hello")),
      schemaMinLength->validate(String("")),
    ),
    //
    (
      //
      Ok(Input.String("hello")),
      Error({
        path: None,
        error: String(MinLength(4)),
      }),
    ),
    ~message="MinLength",
  )

  let schemaMaxLength = Schema.String([MaxLength(3)])
  Assert.deepEqual(
    (
      //
      schemaMaxLength->validate(String("hello")),
      schemaMaxLength->validate(String("")),
    ),
    //
    (
      //
      Error({
        path: None,
        error: String(MaxLength(3)),
      }),
      Ok(String("")),
    ),
    ~message="MaxLength",
  )

  let schemaMaxLength = Schema.String([MinLength(3), Trimmed])
  Assert.deepEqual(
    (
      //
      schemaMaxLength->validate(String("  hello   ")),
      schemaMaxLength->validate(String("      ")),
    ),
    //
    (
      //
      Ok(String("hello")),
      Error({
        path: None,
        error: String(MinLength(3)),
      }),
    ),
    ~message="Trimmed",
  )
})
