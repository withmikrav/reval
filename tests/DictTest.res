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
      schema->validate(Array([])),
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
      Error({
        path: None,
        error: Dict(InvalidType),
      }),
    ),
  )

  let schema = Schema.Dict([Function("isLengthNot2", arr => arr->Js.Array2.length != 2)], [])
  Assert.deepEqual(
    ~message="Function",
    (
      schema->validate(Dict([("name", String("hello"))])),
      schema->validate(Dict([("email", String("hello")), ("name", String("hello"))])),
    ),
    (
      Ok(Dict([("name", String("hello"))])),
      Error({
        path: None,
        error: Dict(Function("isLengthNot2")),
      }),
    ),
  )

  let schema = Schema.Dict(
    [
      Transform(
        d =>
          d->Js.Array2.filter(((k, _v)) => {
            k->Js.String2.startsWith("a")
          }),
      ),
    ],
    [],
  )
  Assert.deepEqual(
    ~message="Transform",
    (
      //
      schema->validate(
        Dict([("abc", String("abc")), ("aa", String("aa")), ("bca", String("bcs"))]),
      ),
      schema->validate(Dict([("test", String("test"))])),
    ),
    //
    (
      //
      Ok(Dict([("abc", String("abc")), ("aa", String("aa"))])),
      Ok(Dict([])),
    ),
  )
})
