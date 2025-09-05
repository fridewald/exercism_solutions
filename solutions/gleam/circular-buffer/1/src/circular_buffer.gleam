import gleam/bool
import gleam/dict

pub opaque type CircularBuffer(t) {
  CircularBuffer(
    data: dict.Dict(Int, t),
    read_pos: Int,
    write_pos: Int,
    size: Int,
  )
}

pub fn new(capacity: Int) -> CircularBuffer(t) {
  CircularBuffer(size: capacity, data: dict.new(), read_pos: 0, write_pos: 0)
}

pub fn read(buffer: CircularBuffer(t)) -> Result(#(t, CircularBuffer(t)), Nil) {
  let CircularBuffer(data:, read_pos:, size:, ..) = buffer
  case dict.get(data, read_pos) {
    Ok(item) ->
      Ok(#(
        item,
        CircularBuffer(
          ..buffer,
          data: dict.drop(data, [read_pos]),
          read_pos: { read_pos + 1 } % size,
        ),
      ))
    _ -> Error(Nil)
  }
}

pub fn write(
  buffer: CircularBuffer(t),
  item: t,
) -> Result(CircularBuffer(t), Nil) {
  let CircularBuffer(size:, data:, read_pos:, write_pos:) = buffer
  case dict.is_empty(data), read_pos == write_pos {
    True, _ | False, False -> {
      Ok(
        CircularBuffer(
          ..buffer,
          data: dict.insert(data, write_pos, item),
          write_pos: { write_pos + 1 } % size,
        ),
      )
    }
    False, True -> Error(Nil)
  }
}

pub fn overwrite(buffer: CircularBuffer(t), item: t) -> CircularBuffer(t) {
  let CircularBuffer(size:, data:, read_pos:, write_pos:) = buffer
  case dict.is_empty(buffer.data), read_pos == write_pos {
    False, True -> {
      let new_pos = { read_pos + 1 } % size
      CircularBuffer(
        ..buffer,
        data: dict.insert(data, write_pos, item),
        read_pos: new_pos,
        write_pos: new_pos,
      )
    }
    True, _ | _, False ->
      CircularBuffer(
        ..buffer,
        data: dict.insert(data, write_pos, item),
        write_pos: { write_pos + 1 } % size,
      )
  }
}

pub fn clear(buffer: CircularBuffer(t)) -> CircularBuffer(t) {
  use <- bool.guard(dict.is_empty(buffer.data), buffer)
  let CircularBuffer(size:, data:, read_pos:, ..) = buffer
  CircularBuffer(
    ..buffer,
    data: dict.drop(data, [read_pos]),
    read_pos: { read_pos + 1 } % size,
  )
}
