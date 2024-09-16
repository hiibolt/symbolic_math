def evaluate ( exp, vars ):
  fold exp:
    # Constants
    case M/Zero:
      return abn_new_ta(0, List/Nil);

    # Values
    case M/ABN:
      return exp.value;
    case M/Var:
      return vars[exp.name];

    # Basic Arithmetic Operations
    case M/Add:
      return abn_add(exp.augend, exp.addend);
    case M/Sub:
      return abn_sub(exp.minuend, exp.subtrahend);
    case M/Mul:
      return abn_mul(exp.multiplier, exp.multiplicand);
    #case M/Div:
    #  return exp.numerator / exp.denominator;

    # Unusual Operations
    #case M/Factorial:
    #  return factorial(exp.operand);

    # Basic Trig Operations
    #case M/Sin:
    #  return sin(exp.theta, exp.terms);