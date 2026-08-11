(rows as number, cols as number) as list =>
let
    scale =
        Number.Sqrt(
            2.0 / cols
        )
in
    List.Buffer(
        List.Transform(
            {1..rows},
            each
                List.Buffer(
                    List.Transform(
                        {1..cols},
                        each
                            (Number.Random() * 2.0 - 1.0)
                            * scale
                    )
                )
        )
    )
