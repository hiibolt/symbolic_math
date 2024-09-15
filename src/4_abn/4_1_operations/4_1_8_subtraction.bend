# Subtracts two ABN numbers using their token arrays
#
# Notes:
# * The first ABN number must be greater than or equal to the second ABN number,
#    which is why we use a helper function that ensures the first number is bigger
#
# Example:
# ```bend
# abn_subtract(new_abn("-123.4"), new_abn("-123.4"))
# ```
def abn_sub ( abn_1, abn_2 ):
  match abn_1:
    case ABN/TokenArray:
      match abn_2:
        case ABN/TokenArray:
          # Check our minuend's sign
          if abn_1.sign == 0:
            if abn_2.sign == 0:
              # We first need to check which is bigger
              if bigger_ta(abn_1.ta, abn_2.ta) == 1:
                result = abn_sub_promise_bigger(abn_1, abn_2)

                match result:
                  case ABN/TokenArray:
                    return abn_new_ta(0, result.ta )
              else:
                result = abn_sub_promise_bigger(abn_2, abn_1)

                match result:
                  case ABN/TokenArray:
                    return abn_new_ta(1, result.ta )
            else: # In this case, we're effectively adding the two numbers
              return abn_add_promise_positive(abn_1, abn_2)
          else: # We are negative
            if abn_2.sign == 0: # If the minuend is positive, we're effectively adding two negative numbers
              result = abn_add_promise_positive(abn_1, abn_2)

              match result:
                case ABN/TokenArray:
                  return abn_new_ta(1, result.ta)
            else:
              # We first need to check which is bigger
              if bigger_ta(abn_1.ta, abn_2.ta) == 1:
                result = abn_sub_promise_bigger(abn_1, abn_2)

                match result:
                  case ABN/TokenArray:
                    return abn_new_ta(1, result.ta )
              else:
                result = abn_sub_promise_bigger(abn_2, abn_1)

                match result:
                  case ABN/TokenArray:
                    return abn_new_ta(0, result.ta)
def abn_sub_promise_bigger( abn_1, abn_2 ):
  match abn_1:
    case ABN/TokenArray:
      match abn_2:
        case ABN/TokenArray:
          # Split the ABN into left and right of the decimal point
          left_1 = until_decimal(abn_1.ta)
          right_1 = after_decimal(abn_1.ta)
          left_1_len = len(left_1)
          right_1_len = len(right_1)

          left_2 = until_decimal(abn_2.ta)
          right_2 = after_decimal(abn_2.ta)
          left_2_len = len(left_2)
          right_2_len = len(right_2)

          # Find the larger length of the left side
          if left_1_len > left_2_len:
            req_left_length = left_1_len
          else:
            req_left_length = left_2_len
          
          # Add leading zeros to the left side of the decimal point
          #  to make the lengths equal
          new_left_1 = add_leading_zeros(left_1, req_left_length)
          new_left_2 = add_leading_zeros(left_2, req_left_length)

          # Find the larger length of the right side
          if right_1_len > right_2_len:
            req_right_length = right_1_len
          else:
            req_right_length = right_2_len
          
          # Add trailing zeros to the right side of the decimal point
          #  to make the lengths equal
          new_right_1 = add_trailing_zeros(right_1, req_right_length)
          new_right_2 = add_trailing_zeros(right_2, req_right_length)

          # Combine the left and right sides of each
          full_1 = List/concat(new_left_1, new_right_1)
          full_2 = List/concat(new_left_2, new_right_2)

          # Subtract the token arrays
          result = List/reverse(subtract_token_array(List/reverse(full_1), List/reverse(full_2), 0))

          # Re-insert the decimal point
          #  (accomplished by making no changes until 
          #  the index is 0, then adding the decimal point, 
          #  then continuing)
          result = insert_decimal_point(result, req_left_length)

          # Remove leading and trailing zeros
          result = remove_leading_zeros(result)
          result = remove_trailing_zeros(result)

          return abn_new_ta(0, result)