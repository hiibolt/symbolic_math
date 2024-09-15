# Adds two ABN numbers using their token arrays
#
# Notes:
# * The token arrays are assumed to be positive
#
# Example:
# ```bend
# abn_add(new_abn("-123.4"), new_abn("-123.4"))
# ```
def abn_add ( abn_1, abn_2 ):
  match abn_1:
    case ABN/TokenArray:
      match abn_2:
        case ABN/TokenArray:
          # Check our signs
          if abn_1.sign == 0:
            if abn_2.sign == 0:
              return abn_add_promise_positive(abn_1, abn_2)
            else:
              return abn_sub(abn_1, abn_new_ta(0, abn_2.ta ) )
          else:
            if abn_2.sign == 0:
              return abn_sub(abn_2, abn_new_ta(0, abn_1.ta ) )
            else:
              result = abn_add_promise_positive(abn_1, abn_2)

              match result:
                case ABN/TokenArray:
                  return abn_new_ta(1, result.ta)
def abn_add_promise_positive ( abn_1, abn_2 ):
  match abn_1:
    case ABN/TokenArray:
      match abn_2:
        case ABN/TokenArray:
          # Split the ABN into left and right of the decimal point
          left_1 = until_decimal(abn_1.ta)
          right_1 = after_decimal(abn_1.ta)
          right_1_len = len(right_1)

          left_2 = until_decimal(abn_2.ta)
          right_2 = after_decimal(abn_2.ta)
          right_2_len = len(right_2)

          # Add the left sides of the decimal point
          new_left = List/reverse(add_token_array(List/reverse(left_1), List/reverse(left_2), 0))

          # Notate the length of the right side of the decimal point
          if right_1_len > right_2_len:
            old_right_length = right_1_len
          else:
            old_right_length = right_2_len
          
          new_right = List/reverse(add_token_array(List/reverse(right_1), List/reverse(right_2), 0))

          if len(new_right) > old_right_length:
            # Carry the 1 from the decimal point
            new_left = List/reverse(add_token_array(List/reverse(new_left), List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Nil }, 0))

            # Remove the 1 from the right side
            new_right = tail(new_right)

            return abn_new_ta(0, List/concat(new_left, List/Cons { head: ABNToken/DecimalPoint, tail: new_right }) )
          else:
            return abn_new_ta(0, List/concat(new_left, List/Cons { head: ABNToken/DecimalPoint, tail: new_right }) )