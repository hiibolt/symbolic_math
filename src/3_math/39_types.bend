type M:
  # Constants
  Zero
  #PI

  # Values
  ABN { value }
  #Var { name }

  # Basic Arithmetic Operations
  Add  { ~augend,     ~addend         }
  Sub  { ~minuend,    ~subtrahend     }
  #Mul  { ~multiplier, ~multiplicand   }
  #Div  { ~numerator,  ~denominator    }

  #Exp  { ~base,       ~exponent       }
  #Root { ~degree,     ~radicand       }
  #Log  { ~base,       ~anti_logarithm }
  #Factorial { ~operand }

  # Basic Trigonometric Operations
  #  * All operations are calculated in radians.
  #Sin { ~theta, terms }