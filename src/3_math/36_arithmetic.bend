def factorial(n):
  if n == +0.0:
    return +1.0
  else:
    return n * factorial(n - +1.0)

# Calculates the base to the power of n divided by the factorial - helps avoid overflow
def pow_factorial(base, n):
  bend ind = +0.0:
    when ind < n:
      term = +1.0
      result = term + fork( n + +1.0 )
    else:
      result = +0.0
  
  return result