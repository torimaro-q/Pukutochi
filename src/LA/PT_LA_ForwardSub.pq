(L as list, b as list) as list =>
let
    Lbuf = List.Buffer(L),
    bbuf = List.Buffer(b),
    n = List.Count(Lbuf),

    y =
        List.Accumulate(
            {0..n-1},
            List.Repeat({0.0}, n),

            (state, i) =>
                let
                    sum =
                        if i = 0 then
                            0.0
                        else
                            List.Sum(
                                List.Transform(
                                    {0..i-1},
                                    (k) =>
                                        Lbuf{i}{k}
                                        * state{k}
                                )
                            ),

                    yi =
                        (bbuf{i} - sum)
                        / Lbuf{i}{i}
                in
                    List.ReplaceRange(
                        state,
                        i,
                        1,
                        {yi}
                    )
        )
in
    y
