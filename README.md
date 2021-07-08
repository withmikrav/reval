# Reval

Simple validation schema for Rescript.

## Install

```sh
npm install @mikrav/reval
```

## Usage
```re
open Reval

let schema = Schema.Dict(
  [RequiredKeys(["name", "age"])],
  [
    //
    ("name", String([MinLength(2)])),
    ("age", Int([GTE(0)])),
    ("description", String([NotEmpty])),
  ],
)

let input = Input.Dict([
  //
  ("name", String("Moona"))
  ("age", Int(3)),
  ("description", String("Hello"))
])

validate(schema, input)

// output:
// result<Input.t, Error.t>
```
