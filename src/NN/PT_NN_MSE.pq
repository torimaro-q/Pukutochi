(y as list, t as list) as number =>
let
    n =
        List.Count(y),

    loss =
        List.Sum(
            List.Transform(
                List.Positions(y),
                (i) =>
                    let
                        d = y{i} - t{i}
                    in
                        d * d
            )
        ) / n
in
    loss
