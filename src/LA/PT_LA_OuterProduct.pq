(d as list, x as list) as list =>
List.Transform(
    d,
    (di) =>
        List.Transform(
            x,
            each di * _
        )
)
