# Multiplies two okenArrays
#
# Example:
# ```bend
# abn_multiply(new_abn("123.4"), new_abn("123.4"))
# ```
def abn_mul ( abn_1, abn_2 ):
  match abn_1:
    case ABN/TokenArray:
      match abn_2:
        case ABN/TokenArray:
          # Get the left and right sides of the decimal point
          left_1 = until_decimal(abn_1.ta)
          right_1 = after_decimal(abn_1.ta)
          left_2 = until_decimal(abn_2.ta)
          right_2 = after_decimal(abn_2.ta)

          # Calculate the number of decimal places
          decimal_point = len(right_1) + len(right_2)

          # Rejoin the left and right sides of the decimal point
          full_1 = List/reverse(List/concat(left_1, right_1))
          full_2 = List/reverse(List/concat(left_2, right_2))

          # Multiply the two token arrays
          result_ta = List/reverse(mul_ta_promise_positive(full_1, full_2))

          # Reinsert the decimal point
          result_ta = insert_decimal_point(result_ta, len(result_ta) - decimal_point)

          # Remove trailing zeros
          result_ta = remove_trailing_zeros(result_ta)

          # Decide the sign
          if abn_1.sign == abn_2.sign:
            return abn_new_ta(0, result_ta)
          else:
            return abn_new_ta(1, result_ta)


# This helper function multiplies two token arrays together
#
# Notes:
# * This function assumes there is no decimal point
# * This function assumes the token arrays are positive
def mul_ta_promise_positive ( ta_1, ta_2 ):
  # We multiply each DIGIT of ta_2 individually by ta_1,
  #  pad the result with increasing zeros, and add them together
  idx = 0
  fold ta_2 with idx:
    case List/Cons:
      match ta_2.head:
        case ABNToken/Digit:
          product = abn_times_digit(ta_1, ta_2.head.value, 0)
          
          # Pad the product with zeros
          padded_product = add_leading_zeros(product, len(product) + idx)
          
          return add_token_array(ta_2.tail(idx + 1), padded_product, 0)
        case ABNToken/DecimalPoint:
          return List/Nil
    case List/Nil:
      return List/Nil



# This helper function only multiplies a token array by a single digit
# 
# Notes:
# * This function assumes there is no decimal point
def abn_times_digit ( ta, dig, carry ):
  match ta:
    case List/Cons:
      match ta.head:
        case ABNToken/Digit:
          product = ta.head.value * dig + carry
          
          if product > 9:
            return List/Cons { head: ABNToken/Digit { value: product % 10 }, tail: abn_times_digit(ta.tail, dig, product / 10) }
          else:
            return List/Cons { head: ABNToken/Digit { value: product }, tail: abn_times_digit(ta.tail, dig, 0) }
          
        case ABNToken/DecimalPoint:
          return List/Nil
    case List/Nil:
      if carry > 0:
        return List/Cons { head: ABNToken/Digit { value: carry }, tail: List/Nil }
      else:
        return List/Nil

