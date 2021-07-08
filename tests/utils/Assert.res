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
