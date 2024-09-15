# Returns the everything before the decimal point
#
# Example:
# ```bend
# until_decimal(List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Cons { head: ABNToken/Digit { value: 2 }, tail: List/Cons { head: ABNToken/DecimalPoint, tail: List/Cons { head: ABNToken/Digit { value: 3 }, tail: List/Nil } } } })
# ```
def until_decimal ( ta ):
  fold ta:
    case List/Cons:
      match ta.head:
        case ABNToken/DecimalPoint:
          return List/Nil
        case _:
          return List/Cons { head: ta.head, tail: ta.tail }
    case List/Nil:
      return List/Nil

# Returns the everything after the decimal point
#
# Example:
# ```bend
# after_decimal(List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Cons { head: ABNToken/Digit { value: 2 }, tail: List/Cons { head: ABNToken/DecimalPoint, tail: List/Cons { head: ABNToken/Digit { value: 3 }, tail: List/Nil } } } })
# ```
def after_decimal ( ta ):
  found = 0
  fold ta with found:
    case List/Cons:
      match ta.head:
        case ABNToken/DecimalPoint:
          return ta.tail(1)
        case _:
          if found == 1:
            return List/Cons { head: ta.head, tail: ta.tail(1) }
          else:
            return ta.tail(0)
    case List/Nil:
      return List/Nil

# Adds leading zeros to a token array
#
# Example:
# ```bend
# add_leading_zeros(List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Nil }, 5)
# ```
def add_leading_zeros ( ta, length ):
  if len(ta) < length:
    return List/Cons { head: ABNToken/Digit { value: 0 }, tail: add_leading_zeros(ta, length - 1) }
  else:
    return ta

# Adds trailing zeros to a token array
#
# Example:
# ```bend
# add_trailing_zeros(List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Nil }, 5)
# ```
def add_trailing_zeros ( ta, length ):
  return List/reverse(add_leading_zeros(List/reverse(ta), length))

# Removes leading zeros from a token array
#
# Example:
# ```bend
# remove_leading_zeros(List/Cons { head: ABNToken/Digit { value: 0 }, tail: List/Cons { head: ABNToken/Digit { value: 0 }, tail: List/Cons { head: ABNToken/Digit { value: 0 }, tail: List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Nil } } } })
# ```
def remove_leading_zeros ( ta ):
  match ta:
    case List/Cons:
      match ta.head:
        case ABNToken/Digit:
          if ta.head.value == 0:
            return remove_leading_zeros(ta.tail)
          else:
            return ta
        case _:
          return ta
    case List/Nil:
      return List/Nil

# Removes trailing zeros from a token array
#
# Example:
# ```bend
# remove_trailing_zeros(List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Cons { head: ABNToken/Digit { value: 0 }, tail: List/Cons { head: ABNToken/Digit { value: 0 }, tail: List/Cons { head: ABNToken/Digit { value: 0 }, tail: List/Nil } } } })
# ```
def remove_trailing_zeros ( ta ):
  return List/reverse(remove_leading_zeros(List/reverse(ta)))

# Subtracts two token arrays. 
#
# Notes:
# * The first token array must be greater than or equal to the second token array.
#
# Example:
# ```bend
# subtract_token_array(List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Nil }, List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Nil }, 0)
# ```
def subtract_token_array ( ta_1, ta_2, borrow ):
  diff = to_i24(borrow)
  nil = 0
  match ta_1:
    case List/Cons:
      match ta_1.head:
        case ABNToken/Digit:
          new_diff = to_i24(ta_1.head.value) - diff
        case _:
          new_diff = diff
      new_nil = nil
      new_ta_1 = ta_1.tail

      diff, nil, ta_1 = new_diff, new_nil, new_ta_1
    case List/Nil:
      new_diff = diff
      new_nil = nil + 1
      new_ta_1 = List/Nil

      diff, nil, ta_1 = new_diff, new_nil, new_ta_1
  
  match ta_2:
    case List/Cons:
      match ta_2.head:
        case ABNToken/Digit:
          new_diff = diff - to_i24(ta_2.head.value)
        case _:
          new_diff = diff
      new_nil = nil
      new_ta_2 = ta_2.tail

      diff, nil, ta_2 = new_diff, new_nil, new_ta_2
    case List/Nil:
      new_diff = diff
      new_nil = nil + 1
      new_ta_2 = List/Nil

      diff, nil, ta_2 = new_diff, new_nil, new_ta_2

  if nil < 2:
    if diff < 0:
      return List/Cons { head: ABNToken/Digit { value: diff + +10 }, tail: subtract_token_array(ta_1, ta_2, 1) }
    else:
      return List/Cons { head: ABNToken/Digit { value: diff }, tail: subtract_token_array(ta_1, ta_2, 0) }
  else:
    if diff > 0:
      return List/Cons { head: ABNToken/Digit { value: diff }, tail: List/Nil }
    else:
      return List/Nil
def bigger_ta ( ta_1, ta_2 ):
  match ta_1:
    case List/Cons:
      match ta_2:
        case List/Cons:
          # Primary case: both token arrays are non-empty
          match ta_1.head:
            case ABNToken/Digit:
              match ta_2.head:
                case ABNToken/Digit:
                  if ta_1.head.value > ta_2.head.value:
                    return 1
                  else:
                    if ta_1.head.value < ta_2.head.value:
                      return 2
                    else:
                      return bigger_ta(ta_1.tail, ta_2.tail)
                case _:
                  return 1
            case _:
              return 1

        case List/Nil:
          return 1
    case List/Nil:
      return 2
def insert_decimal_point ( ta, index ):
  match ta:
    case List/Cons:
      if index == 0:
        return List/Cons { head: ABNToken/DecimalPoint, tail: insert_decimal_point(ta, index - 1) }
      else:
        return List/Cons { head: ta.head, tail: insert_decimal_point(ta.tail, index - 1) }
    case List/Nil:
      return List/Nil

# Adds two token arrays
#
# Example:
# ```bend
# add_token_array(List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Nil }, List/Cons { head: ABNToken/Digit { value: 1 }, tail: List/Nil }, 0)
# ```
def add_token_array ( ta_1, ta_2, carry ):
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
      return List/Cons { head: ABNToken/Digit { value: sum - 10 }, tail: add_token_array(ta_1, ta_2, 1) }
    else:
      return List/Cons { head: ABNToken/Digit { value: sum }, tail: add_token_array(ta_1, ta_2, 0) }
  else:
    if sum < 10:
      if sum > 0:
        return List/Cons { head: ABNToken/Digit { value: sum }, tail: List/Nil }
      else:
        return List/Nil
    else:
      return List/Cons { head: ABNToken/Digit { value: sum - 10 }, tail: List/Cons { head: 1, tail: List/Nil } }
