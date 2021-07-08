Test.test("Reval.Int", () => {
  let validate = Schema.validate

  let schema = Schema.Int([Equal(2)])
  Assert.deepEqual(
    ~message="Equal",
    (
      //
      schema->validate(Int(2)),
      schema->validate(Int(1)),
      schema->validate(Float(1.)),
    ),
    //
    (
      //
      Ok(Int(2)),
      Error({
        path: None,
        error: Int(Equal(2)),
      }),
      Error({
        path: None,
        error: Int(InvalidType),
      }),
    ),
  )

  let schema = Schema.Int([GT(2)])
  Assert.deepEqual(
    ~message="GT",
    (
      //
      schema->validate(Int(4)),
      schema->validate(Int(2)),
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
  )

  let schema = Schema.Int([GTE(2)])
  Assert.deepEqual(
    ~message="GTE",
    (
      //
      schema->validate(Int(4)),
      schema->validate(Int(2)),
      schema->validate(Int(1)),
    ),
    //
    (
      //
      Ok(Int(4)),
      Ok(Int(2)),
      Error({
        path: None,
        error: Int(GTE(2)),
      }),
    ),
  )

  let schema = Schema.Int([LT(4)])
  Assert.deepEqual(
    ~message="LT",
    (
      //
      schema->validate(Int(2)),
      schema->validate(Int(4)),
      schema->validate(Int(5)),
    ),
    //
    (
      //
      Ok(Int(2)),
      Error({
        path: None,
        error: Int(LT(4)),
      }),
      Error({
        path: None,
        error: Int(LT(4)),
      }),
    ),
  )

  let schema = Schema.Int([LTE(4)])
  Assert.deepEqual(
    ~message="LTE",
    (
      //
      schema->validate(Int(2)),
      schema->validate(Int(4)),
      schema->validate(Int(5)),
    ),
    //
    (
      //
      Ok(Int(2)),
      Ok(Int(4)),
      Error({
        path: None,
        error: Int(LTE(4)),
      }),
    ),
  )

  let schema = Schema.Int([Function("isNotOne", int => int != 1)])
  Assert.deepEqual(
    ~message="Function",
    (
      //
      schema->validate(Int(2)),
      schema->validate(Int(1)),
      schema->validate(Int(3)),
    ),
    //
    (
      //
      Ok(Int(2)),
      Error({
        path: None,
        error: Int(Function("isNotOne")),
      }),
      Ok(Int(3)),
    ),
  )

  let schema = Schema.Int([Transform(f => f + 1)])
  Assert.deepEqual(
    ~message="Transform",
    (
      //
      schema->validate(Int(2)),
      schema->validate(Int(1)),
      schema->validate(Int(3)),
    ),
    //
    (
      //
      Ok(Int(3)),
      Ok(Int(2)),
      Ok(Int(4)),
    ),
  )
})
