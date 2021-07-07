Test.test("Reval.Dict", () => {
  let validate = Schema.validate

  let childSchema = Schema.String([MinLength(2)])
  let schema = Schema.Dict([RequiredKeys(["name"])], [("name", childSchema)])

  Assert.deepEqual(
    ~message="RequiredKeys",
    (
      schema->validate(Dict([("name", String("hello"))])),
      schema->validate(Dict([("email", String("hello"))])),
      schema->validate(Dict([("name", String(""))])),
      1,
    ),
    (
      Ok(Dict([("name", String("hello"))])),
      Error({
        path: None,
        error: Dict(RequiredKeys(["name"])),
      }),
      Error({
        path: Some("name"),
        error: String(MinLength(2)),
      }),
      1,
    ),
  )
})
