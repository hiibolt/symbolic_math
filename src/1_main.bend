def main: 
  # Example for ABN
  abn_1 = abn_new("996789.96785679564")
  abn_2 = abn_new("5671.056786789")

  abn_3 = abn_add(abn_1, abn_2)

  abn_result = format([
    P/Str { val: "Adding:" },
    P/Br,
    P/ABN { val: abn_1 },
    P/Br,
    P/Br,
    P/Str { val: "And:" },
    P/Br,
    P/ABN { val: abn_2 },
    P/Br,
    P/Br,
    P/Str { val: "Gives:" },
    P/Br,
    P/ABN { val: abn_3 },
    P/Br,
    P/Br,
    P/Br
  ])

  # Example for math
  value = evaluate(M/Add { 
    augend: M/ABN { value: abn_new("1.0") },
    addend: M/ABN { value: abn_new("2.0") }
  })
  exp_result = format([
    P/Str { val: "Math Expression Example: "},
    P/ABN { val: value },
    P/Br
  ])
  
  with IO:
    * <- IO/FS/write(1, "[ Title - ABN PoC - Bend ]\n")
    * <- IO/FS/write(1, "[   Author - @hiibolt    ]\n")
    * <- IO/FS/write(1, abn_result)

    * <- IO/FS/write(1, exp_result) 

    return 1