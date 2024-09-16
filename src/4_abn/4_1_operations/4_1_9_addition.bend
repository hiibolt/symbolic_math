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

          # Add the token arrays
          result_ta = add_token_array(full_1, full_2, 0)

          # Re-insert the decimal point
          result_ta = insert_decimal_point(result_ta, len(result_ta) - right_1_len)

          return abn_new_ta(0, result_ta)