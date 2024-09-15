def until_decimal ( ta ):
  fold ta:
    case List/Cons:
      match ta.head:
        case ABNToken/DecimalPoint:
          return List/Nil
        case _:
          return List/Cons { head: ta.head, tail: ta.tail }
    case List/Nil:
      return List/Nil

def after_decimal ( ta ):
  found = 0
  fold ta with found:
    case List/Cons:
      match ta.head:
        case ABNToken/DecimalPoint:
          return ta.tail(1)
        case _:
          if found == 1:
            return List/Cons { head: ta.head, tail: ta.tail(1) }
          else:
            return ta.tail(0)
    case List/Nil:
      return List/Nil