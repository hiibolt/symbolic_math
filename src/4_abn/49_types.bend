type ABN:
  TokenArray { sign, ta }
type ABNToken:
  Digit { value }
  DecimalPoint


# Converts a token array and a sign to an ABN
#
# Notes:
# - The sign is 1 for negative and 0 for positive
# - Zero is represented as an empty token array
# - If intial token array is empty, the sign is 0
#
# Example:
# ```bend
# new_abn_ta(1, List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Nil })
# ```
def abn_new_ta ( sign, ta ):
  match ta:
    case List/Cons:
      match ta.head:
        case ABNToken/Digit:
          return ABN/TokenArray { sign: sign, ta: ta }
        case ABNToken/DecimalPoint:
          return ABN/TokenArray { sign: sign, ta: List/Nil }
    case List/Nil:
      return ABN/TokenArray { sign: 0, ta: List/Nil }

# Takes a string and converts it to an ABN
#
# Example:
# ```bend
# new_abn("-123.456")
# ```
def abn_new ( str ):
  match str:
    case String/Cons:
      if str.head == 45:
        sign = 1
      else:
        sign = 0
    case String/Nil:
      sign = 0

  return abn_new_ta(sign, string_to_token_list(str))

# Converts a String type to a List type of ABN tokens
#
# Example:
# ```bend
# new_abn("-123.456")
# ```
def abn_to_str ( abn ):
  match abn:
    case ABN/TokenArray:
      if abn.sign == 1:
        return List/Cons { head: 45, tail: token_list_to_string(abn.ta) }
      else:
        match abn.ta:
          case List/Cons:
            return token_list_to_string(abn.ta)
          case List/Nil:
            return List/Cons { head: 48, tail: List/Nil }