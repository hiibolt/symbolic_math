def main: 
  # Basic Example for math
  expression = M/Add { 
    augend: M/ABN { value: abn_new("-100.0") },
    addend: M/Sub {
      minuend: M/ABN { value: abn_new("100.0") },
      subtrahend: M/Sub {
        minuend: M/ABN { value: abn_new("-2.0003") },
        subtrahend: M/ABN { value: abn_new("1.0001") }
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
  expression_result = format([
    P/Str { val: "Outcome: "},
    P/ABN { val: evaluate(expression) },
    P/Br, P/Br
  ])
  
  with IO:
    * <- IO/FS/write(1, "[    ABN PoC - Bend     ]\n")
    * <- IO/FS/write(1, "[   Author - @hiibolt   ]\n\n")

    * <- IO/FS/write( 1, expression_strignified )
    * <- IO/FS/write( 1, expression_result      )

    * <- IO/FS/write( 1, "[  End of Program  ]\n")

    return 1