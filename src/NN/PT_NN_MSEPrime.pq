(y as list, t as list) as list =>
let
    n =
        List.Count(y)
in
    List.Transform(
        List.Positions(y),
        (i) =>
            2.0 * (y{i} - t{i}) / n
    )
