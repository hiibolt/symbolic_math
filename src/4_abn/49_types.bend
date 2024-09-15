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
# new_abn("-123.456")
# ```
def abn_new ( string ):
  return ABN/TokenArray { ta: string_to_token_list(string) }
def abn_new_ta ( ta ):
  return ABN/TokenArray { ta: ta }

# Converts a String type to a List type of ABN tokens
#
# Example:
# ```bend
# new_abn("-123.456")
# ```
def abn_to_str ( abn ):
  match abn:
    case ABN/TokenArray:
      return token_list_to_string(abn.ta)