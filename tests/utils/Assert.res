open Test

let equalFn = (a, b) => a === b
let notEqualFn = (a, b) => a !== b

let equal = (~message=?, ~operator="equal", a, b) => {
  assertion(
    //
    ~message?,
    ~operator,
    equalFn,
    a,
    b,
  )
}

let deepEqual = (~message=?, ~operator="deepEqual", a: 'a, b: 'a) => {
  assertion(
    //
    ~message?,
    ~operator,
    equalFn,
    Js.Json.stringifyAny(a),
    Js.Json.stringifyAny(b),
  )
}

let notEqual = (~message=?, ~operator="notEqual", a, b) => {
  assertion(
    //
    ~message?,
    ~operator,
    notEqualFn,
    a,
    b,
  )
}

let isTrue = (~message=?, ~operator="isTrue", str) => {
  assertion(
    //
    ~message?,
    ~operator,
    equalFn,
    str,
    true,
  )
}

let isFalse = (~message=?, ~operator="isFalse", str) => {
  assertion(
    //
    ~message?,
    ~operator,
    equalFn,
    str,
    false,
  )
}

let match = (~message=?, ~operator="match", str, re) => {
  assertion(
    //
    ~message?,
    ~operator,
    equalFn,
    str->Js.String2.match_(re)->Belt.Option.isSome,
    true,
  )
}
