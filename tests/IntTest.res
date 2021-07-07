Test.test("Reval.Int", () => {
  let validate = Schema.validate

  let schemaRequired = Schema.Int([GT(2)])
  Assert.deepEqual(
    (
      //
      schemaRequired->validate(Int(4)),
      schemaRequired->validate(Int(1)),
    ),
    //
    (
      //
      Ok(Int(4)),
      Error({
        path: None,
        error: Int(GT(2)),
      }),
    ),
    ~message="GT",
  )
})
