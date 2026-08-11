(u as list, v as list) as number =>
let
    n = List.Count(u)
in
    List.Sum(
        List.Transform(
            {0..n-1},
            (i) => u{i} * v{i}
        )
    )
