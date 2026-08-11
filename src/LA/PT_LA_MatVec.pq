(W as list, x as list) as list =>
List.Transform(
    W,
    (row) => PT_LA_Dot(row, x)
)
