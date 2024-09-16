def u24_to_string(n):
  bend i = n:
    when i > 0:
      digit = i % 10

      result = String/Cons { head: digit + 48, tail: fork(i / 10) }
    else:
      result = String/Nil

  return List/reverse(result)
def i24_to_string(n):
  # Check if the number is negative
  was_negative = n < 0

  # If it was negative, make it positive
  if was_negative:
    n = -1 * n
  else:
    n = n

  result = u24_to_string(to_u24(n))

  # If it was negative, add a negative sign
  if was_negative:
    result = String/Cons { head: 45, tail: result }
  else:
    result = result

  return result
def f24_to_string(n):
  # First, handle the sign
  was_negative = n < 0.0

  # If it was negative, make it positive
  if was_negative:
    n = -1.0 * n
  else:
    n = n
    

  # Handle the integer part
  int_part = to_i24(n)
  int_result = i24_to_string(int_part)

  # Handle the fractional part
  bend frac_part = n - to_f24(int_part):
    when frac_part > 0.0:
      frac_part = frac_part * 10.0
      digit = to_i24(frac_part)

      frac_result = String/Cons { head: digit + 48, tail: fork(frac_part - to_f24(digit)) }
    else:
      frac_result = String/Nil

  # If it was negative, add a negative sign to the integer part
  if was_negative:
    int_result = String/Cons { head: 45, tail: int_result }
  else:
    int_result = int_result
  
  # If there was a fractional part, add a decimal point
  match frac_result:
    case String/Cons:
      return List/concat(int_result, String/Cons { head: 46, tail: frac_result })
    case String/Nil:
      return int_result

def exp_to_string ( m ):
  fold m:
    # Constants
    case M/Zero:
      return String/Cons { head: 48, tail: String/Nil }
    #PI

    # Values
    case M/ABN:
      return abn_to_str(m.value)
    case M/Var:
      return String/Cons { head: m.name, tail: List/Nil }

    # Basic Arithmetic Operations
    case M/Add:
      inner = List/concat(m.augend, String/Cons { head: 43, tail: m.addend })

      # Add parentheses
      return List/concat(String/Cons { head: 40, tail: inner }, String/Cons { head: 41, tail: String/Nil })
    case M/Sub:
      inner = List/concat(m.minuend, String/Cons { head: 45, tail: m.subtrahend })

      # Add parentheses
      return List/concat(String/Cons { head: 40, tail: inner }, String/Cons { head: 41, tail: String/Nil })
    case M/Mul:
      inner = List/concat(m.multiplier, String/Cons { head: 42, tail: m.multiplicand })

      # Add parentheses
      return List/concat(String/Cons { head: 40, tail: inner }, String/Cons { head: 41, tail: String/Nil })
    #Div  { ~numerator,  ~denominator    }

    #Exp  { ~base,       ~exponent       }
    #Root { ~degree,     ~radicand       }
    #Log  { ~base,       ~anti_logarithm }
    #Factorial { ~operand }

    # Basic Trigonometric Operations
    #  * All operations are calculated in radians.
    #Sin { ~theta, terms }

def printable_to_bytes( input ):
  match input:
    case P/U24:
      return String/encode_utf8(u24_to_string(input.val))
    case P/I24:
      return String/encode_utf8(i24_to_string(input.val))
    case P/F24:
      return String/encode_utf8(f24_to_string(input.val))
    case P/Str:
      return String/encode_utf8(input.val)
    case P/Br:
      return String/encode_utf8("\n")
    case P/ABN:
      return String/encode_utf8(abn_to_str(input.val))
    case P/Exp:
      return String/encode_utf8(exp_to_string(input.exp))
    case _:
      return String/encode_utf8("[NO STRING REPRESENTATION]")