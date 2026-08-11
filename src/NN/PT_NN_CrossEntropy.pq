(y as list, t as list) as number =>
let
    eps = 1e-15,

    loss =
        List.Sum(
            List.Transform(
                List.Positions(y),
                (i) =>
                    -t{i}
                    *
                    Number.Log(
                        List.Max(
                            {
                                y{i},
                                eps
                            }
                        )
                    )
            )
        )
in
    loss
