type ABN:
  TokenArray { ta }

type ABNToken:
  Digit { value }
  DecimalPoint
  NegativeSign

# Takes a string and converts it to an ABN
#
# Example:
# ```bend
# new_abn("+123.456")
# ```
def new_abn ( string ):
  return ABN/TokenArray { ta: string_to_token_list(string) }

def string_to_token_list ( st ):
  fold st:
    case String/Cons:
      if st.head == 43:
        return List/Cons { head: ABNToken/NegativeSign, tail: st.tail }
      else:
        if st.head == 46:
          return List/Cons { head: ABNToken/DecimalPoint, tail: st.tail }
        else:
          return List/Cons { head: ABNToken/Digit { value: st.head - 48 }, tail: st.tail }
    case String/Nil:
      return List/Nil

def token_list_to_string ( tokens ):
  fold tokens:
    case List/Cons:
      match tokens.head:
        case ABNToken/Digit:
          return String/Cons { head: tokens.head.value + 48, tail: tokens.tail }
        case ABNToken/DecimalPoint:
          return String/Cons { head: 46, tail: tokens.tail }
        case ABNToken/NegativeSign:
          return String/Cons { head: 43, tail: tokens.tail }
    case List/Nil:
      return String/Nil

def abn_to_str ( abn ):
  match abn:
    case ABN/TokenArray:
      return token_list_to_string(abn.ta)

def main: 
  # Example for ABN
  abn_1 = new_abn("-123.4")

  # Print the ABN
  result_0 = abn_to_str(abn_1)

  #result = add_abn(abn_1, abn_2)


  # Example for math
  result_1 = evaluate(M/Add { 
    augend: M/Int { value: +2.0 }, 
    addend: M/Int { value: +2.0 }
  })
  result_2 = evaluate(M/Add { 
    augend: M/Sin { theta: M/PI, terms: +40.0 }, 
    addend: M/Int { value: +2.0 }
  })

  res_result = format([
    P/S { val: "Expression 0: "},
    P/S { val: result_0 },
    P/B
  ])
  exp_1_result = format([
    P/S { val: "Expression 1: "},
    P/F { val: result_1 },
    P/B
  ])
  exp_2_result = format([
    P/S { val: "Expression 2: "},
    P/F { val: result_2 },
    P/B
  ])
  
  with IO:
    * <- IO/FS/write(1, res_result)

    * <- IO/FS/write(1, exp_1_result) 
    * <- IO/FS/write(1, exp_2_result)

    return abn_1
