def sin(theta, num_terms):
  bend n = +0.0:
    when n < num_terms:
      term = (-1.0 ** n) * factorial(+2.0 * n + +1.0)
      result = term + fork( n + +1.0 )
    else:
      result = +0.0

  return result