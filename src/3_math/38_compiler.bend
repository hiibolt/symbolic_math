def evaluate ( exp ):
  fold exp:
    # Constants
    case M/Zero:
      return ABN/TokenArray { ta: List/Nil };

    # Values
    case M/ABN:
      return exp.value;

    # Basic Arithmetic Operations
    case M/Add:
      return abn_add(exp.augend, exp.addend);
    case M/Sub:
      return exp.minuend + exp.subtrahend;
    case M/Mul:
      return exp.multiplier * exp.multiplicand;
    case M/Div:
      return exp.numerator / exp.denominator;

    # Unusual Operations
    case M/Factorial:
      return factorial(exp.operand);

    # Basic Trig Operations
    case M/Sin:
      return sin(exp.theta, exp.terms);