def main: 
  # Basic Example for math
  expression = M/Sub {
    minuend: M/ABN { value: abn_new("-1678.09") },
    subtrahend: M/Mul {
      multiplicand: M/ABN { value: abn_new("260.003") },
      multiplier: M/Add {
        augend: M/ABN { value: abn_new("2.0003") },
        addend: M/Var { name: 'x' }
      }
    }
  }

  # Demonstate its ability to stringify the expression
  expression_strignified = format([
    P/Str { val: "Expression: "},
    P/Exp { exp: expression },
    P/Br, P/Br
  ])

  # Demonstrate its ability to evaluate the expression
  expression_variables = {
    'x': abn_new("-2.0003")
  }
  expression_result = format([
    P/Str { val: "Outcome: "},
    P/ABN { val: evaluate(expression, expression_variables) },
    P/Br, P/Br
  ])
  
  with IO:
    * <- IO/FS/write(1, "[    ABN PoC - Bend     ]\n")
    * <- IO/FS/write(1, "[   Author - @hiibolt   ]\n\n")

    * <- IO/FS/write( 1, expression_strignified )
    * <- IO/FS/write( 1, expression_result      )

    * <- IO/FS/write( 1, "[  End of Program  ]\n")

    return 1