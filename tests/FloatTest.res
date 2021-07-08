Test.test("Reval.Float", () => {
  let validate = Schema.validate

  let schema = Schema.Float([Equal(2.)])
  Assert.deepEqual(
    ~message="Equal",
    (
      //
      schema->validate(Float(2.)),
      schema->validate(Float(1.)),
      schema->validate(Int(1)),
    ),
    //
    (
      //
      Ok(Float(2.)),
      Error({
        path: None,
        error: Float(Equal(2.)),
      }),
      Error({
        path: None,
        error: InvalidType,
      }),
    ),
  )

  let schema = Schema.Float([GT(2.)])
  Assert.deepEqual(
    ~message="GT",
    (
      //
      schema->validate(Float(4.)),
      schema->validate(Float(2.)),
    ),
    //
    (
      //
      Ok(Float(4.)),
      Error({
        path: None,
        error: Float(GT(2.)),
      }),
    ),
  )

  let schema = Schema.Float([GTE(2.)])
  Assert.deepEqual(
    ~message="GTE",
    (
      //
      schema->validate(Float(4.)),
      schema->validate(Float(2.)),
      schema->validate(Float(1.)),
    ),
    //
    (
      //
      Ok(Float(4.)),
      Ok(Float(2.)),
      Error({
        path: None,
        error: Float(GTE(2.)),
      }),
    ),
  )

  let schema = Schema.Float([LT(4.)])
  Assert.deepEqual(
    ~message="LT",
    (
      //
      schema->validate(Float(2.)),
      schema->validate(Float(4.)),
      schema->validate(Float(5.)),
    ),
    //
    (
      //
      Ok(Float(2.)),
      Error({
        path: None,
        error: Float(LT(4.)),
      }),
      Error({
        path: None,
        error: Float(LT(4.)),
      }),
    ),
  )

  let schema = Schema.Float([LTE(4.)])
  Assert.deepEqual(
    ~message="LTE",
    (
      //
      schema->validate(Float(2.)),
      schema->validate(Float(4.)),
      schema->validate(Float(5.)),
    ),
    //
    (
      //
      Ok(Float(2.)),
      Ok(Float(4.)),
      Error({
        path: None,
        error: Float(LTE(4.)),
      }),
    ),
  )

  let schema = Schema.Float([Function("isNotOne", f => f != 1.)])
  Assert.deepEqual(
    ~message="Function",
    (
      //
      schema->validate(Float(2.)),
      schema->validate(Float(1.)),
      schema->validate(Float(3.)),
    ),
    //
    (
      //
      Ok(Float(2.)),
      Error({
        path: None,
        error: Float(Function("isNotOne", f => f != 1.)),
      }),
      Ok(Float(3.)),
    ),
  )
})
