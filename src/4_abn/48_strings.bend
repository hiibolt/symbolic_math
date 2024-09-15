# Converts a String type to a List type of ABN tokens
#
# Example:
# ```bend
# new_abn("-123.456")
# ```
def string_to_token_list ( st ):
  fold st:
    case String/Cons:
      if st.head == 45:
        return st.tail
      else:
        if st.head == 46:
          return List/Cons { head: ABNToken/DecimalPoint, tail: st.tail }
        else:
          return List/Cons { head: ABNToken/Digit { value: st.head - 48 }, tail: st.tail }
    case String/Nil:
      return List/Nil

# Converts an ABT token list to a String type
#
# Example:
# ```bend
# token_list_to_string(new_abn("-123.456"))
# ```
def token_list_to_string ( tokens ):
  fold tokens:
    case List/Cons:
      match tokens.head:
        case ABNToken/Digit:
          return String/Cons { head: tokens.head.value + 48, tail: tokens.tail }
        case ABNToken/DecimalPoint:
          return String/Cons { head: 46, tail: tokens.tail }
    case List/Nil:
      return String/Nil