def tail ( ta ):
  match ta:
    case List/Cons:
      return ta.tail
    case List/Nil:
      return List/Nil
def len ( ta ):
  fold ta:
    case List/Cons:
      return 1 + ta.tail
    case List/Nil:
      return 0