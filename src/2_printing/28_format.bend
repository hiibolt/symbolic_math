def format ( list ):
  fold list:
    case List/Cons:
      return List/concat(printable_to_bytes(list.head), list.tail)
    case List/Nil:
      return []