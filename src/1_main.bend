def main:
  result_1 = evaluate(M/Add { 
    augend: M/Int { value: +2.0 }, 
    addend: M/Int { value: +2.0 }
  })
  result_2 = evaluate(M/Add { 
    augend: M/Sin { theta: M/PI, terms: +40.0 }, 
    addend: M/Int { value: +2.0 }
  })

  exp_1_result = format([
    P/S { val: "Expression 1: "},
    P/F { val: result_1 },
    P/B
  ])
  exp_2_result = format([
    P/S { val: "Expression 2: "},
    P/F { val: result_2 },
    P/B
  ])
  
  with IO:
    * <- IO/FS/write(1, exp_1_result) 
    * <- IO/FS/write(1, exp_2_result)

    return 1
