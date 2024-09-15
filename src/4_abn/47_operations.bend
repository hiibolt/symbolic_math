# Adds two ABN numbers using their token arrays
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
          # Split the ABN into left and right of the decimal point
          left_1 = until_decimal(abn_1.ta)
          right_1 = after_decimal(abn_1.ta)
          right_1_len = len(right_1)

          left_2 = until_decimal(abn_2.ta)
          right_2 = after_decimal(abn_2.ta)
          right_2_len = len(right_2)

          # Add the left sides of the decimal point
          new_left = List/reverse(add_digit_array(List/reverse(left_1), List/reverse(left_2), 0))

          # Notate the length of the right side of the decimal point
          if right_1_len > right_2_len:
            old_right_length = right_1_len
          else:
            old_right_length = right_2_len
          
          new_right = List/reverse(add_digit_array(List/reverse(right_1), List/reverse(right_2), 0))

          if len(new_right) > old_right_length:
            # Carry the 1 from the decimal point
            new_left = List/reverse(add_digit_array(List/reverse(new_left), List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Nil }, 0))

            # Remove the 1 from the right side
            new_right = tail(new_right)

            return ABN/TokenArray { ta: List/concat(new_left, List/Cons { head: ABNToken/DecimalPoint, tail: new_right }) }
          else:
            return ABN/TokenArray { ta: List/concat(new_left, List/Cons { head: ABNToken/DecimalPoint, tail: new_right }) }

def add_digit_array ( ta_1, ta_2, carry ):
  sum = carry
  nil = 0
  match ta_1:
    case List/Cons:
      match ta_1.head:
        case ABNToken/Digit:
          new_sum = sum + ta_1.head.value
        case _:
          new_sum = sum
      new_nil = nil
      new_ta_1 = ta_1.tail

      sum, nil, ta_1 = new_sum, new_nil, new_ta_1
    case List/Nil:
      new_sum = sum
      new_nil = nil + 1
      new_ta_1 = List/Nil

      sum, nil, ta_1 = new_sum, new_nil, new_ta_1
  
  match ta_2:
    case List/Cons:
      match ta_2.head:
        case ABNToken/Digit:
          new_sum = sum + ta_2.head.value
        case _:
          new_sum = sum
      new_nil = nil
      new_ta_2 = ta_2.tail

      sum, nil, ta_2 = new_sum, new_nil, new_ta_2
    case List/Nil:
      new_sum = sum
      new_nil = nil + 1
      new_ta_2 = List/Nil

      sum, nil, ta_2 = new_sum, new_nil, new_ta_2


  if nil < 2:
    if sum > 9:
      return List/Cons { head: ABNToken/Digit { value: sum - 10 }, tail: add_digit_array(ta_1, ta_2, 1) }
    else:
      return List/Cons { head: ABNToken/Digit { value: sum }, tail: add_digit_array(ta_1, ta_2, 0) }
  else:
    if sum < 10:
      if sum > 0:
        return List/Cons { head: ABNToken/Digit { value: sum }, tail: List/Nil }
      else:
        return List/Nil
    else:
      return List/Cons { head: ABNToken/Digit { value: sum - 10 }, tail: List/Cons { head: 1, tail: List/Nil } }