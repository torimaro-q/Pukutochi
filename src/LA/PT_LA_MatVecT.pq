(W as list, x as list) as list =>
let
    cols = List.Count(W{0}),
    rows = List.Positions(W)
in
    List.Transform(
        {0..cols-1},
        (j) =>
            List.Sum(
                List.Transform(
                    rows,
                    (i) => W{i}{j} * x{i}
                )
            )
    )
