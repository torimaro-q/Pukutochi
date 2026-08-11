(L as list, y as list) as list =>
let
    Lbuf = List.Buffer(L),
    ybuf = List.Buffer(y),
    n = List.Count(Lbuf),

    x =
        List.Accumulate(
            List.Reverse({0..n-1}),
            List.Repeat({0.0}, n),

            (state, i) =>
                let
                    sum =
                        if i = n - 1 then
                            0.0
                        else
                            List.Sum(
                                List.Transform(
                                    {i+1..n-1},
                                    (k) =>
                                        Lbuf{k}{i}
                                        * state{k}
                                )
                            ),

                    xi =
                        (ybuf{i} - sum)
                        / Lbuf{i}{i}
                in
                    List.ReplaceRange(
                        state,
                        i,
                        1,
                        {xi}
                    )
        )
in
    x
