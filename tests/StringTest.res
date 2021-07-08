Test.test("Reval.String", () => {
  let validate = Schema.validate

  let schema = Schema.String([NotEmpty])
  Assert.deepEqual(
    ~message="NotEmpty",
    (
      //
      schema->validate(String("hello")),
      schema->validate(String("")),
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
  )

  let schema = Schema.String([Length(5)])
  Assert.deepEqual(
    ~message="Length",
    (
      //
      schema->validate(String("hello")),
      schema->validate(String("sdf")),
      schema->validate(String("sdfsdf")),
    ),
    //
    (
      //
      Ok(Input.String("hello")),
      Error({
        path: None,
        error: String(Length(5)),
      }),
      Error({
        path: None,
        error: String(Length(5)),
      }),
    ),
  )

  let schema = Schema.String([MinLength(4)])
  Assert.deepEqual(
    ~message="MinLength",
    (
      //
      schema->validate(String("hello")),
      schema->validate(String("")),
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
  )

  let schema = Schema.String([MaxLength(3)])
  Assert.deepEqual(
    ~message="MaxLength",
    (
      //
      schema->validate(String("hello")),
      schema->validate(String("")),
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
  )

  let schema = Schema.String([MinLength(3), Transform(str => str->Js.String2.trim)])
  Assert.deepEqual(
    ~message="Transform",
    (
      //
      schema->validate(String("  hello   ")),
      schema->validate(String("      ")),
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
  )

  let schema = Schema.String([MatchRegex(%re("/^([0-9])+$/g"))])
  Assert.deepEqual(
    ~message="MatchRegex",
    (
      //
      schema->validate(String("042231")),
      schema->validate(String(" ? sdf")),
    ),
    //
    (
      //
      Ok(String("042231")),
      Error({
        path: None,
        error: String(MatchRegex(%re("/^([0-9])+$/g"))),
      }),
    ),
  )

  let schema = Schema.String([Enum(["Test", "Toast"])])
  Assert.deepEqual(
    ~message="Enum",
    (
      //
      schema->validate(String("Test")),
      schema->validate(String("Toast")),
      schema->validate(String("Not test")),
    ),
    //
    (
      //
      Ok(String("Test")),
      Ok(String("Toast")),
      Error({
        path: None,
        error: String(Enum(["Test", "Toast"])),
      }),
    ),
  )

  let schema = Schema.String([Function("isNotTest", str => str != "Test")])
  Assert.deepEqual(
    ~message="Function",
    (
      //
      schema->validate(String("Not test")),
      schema->validate(String("Test")),
    ),
    //
    (
      //
      Ok(String("Not test")),
      Error({
        path: None,
        error: String(Function("isNotTest")),
      }),
    ),
  )
})
