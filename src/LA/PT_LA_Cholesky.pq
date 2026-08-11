(A as list) as list =>
let
    Abuf = List.Buffer(A),
    n = List.Count(Abuf),

    L =
        List.Accumulate(
            {0..n-1},
            {},

            (state, i) =>
                let
                    Lprev = List.Buffer(state),
                    Arow = Abuf{i},

                    newRow =
                        List.Accumulate(
                            {0..n-1},
                            List.Repeat({0.0}, n),

                            (rowState, j) =>
                                let
                                    value =
                                        if j > i then
                                            0.0

                                        else if j = i then
                                            let
                                                sumSq =
                                                    if i = 0 then
                                                        0.0
                                                    else
                                                        List.Sum(
                                                            List.Transform(
                                                                {0..i-1},
                                                                (k) =>
                                                                    rowState{k}
                                                                    * rowState{k}
                                                            )
                                                        )
                                            in
                                                Number.Sqrt(
                                                    Arow{j} - sumSq
                                                )

                                        else
                                            let
                                                sumProd =
                                                    if j = 0 then
                                                        0.0
                                                    else
                                                        List.Sum(
                                                            List.Transform(
                                                                {0..j-1},
                                                                (k) =>
                                                                    rowState{k}
                                                                    * Lprev{j}{k}
                                                        )
                                                    )
                                            in
                                                (
                                                    Arow{j}
                                                    - sumProd
                                                )
                                                / Lprev{j}{j},

                                    updated =
                                        List.ReplaceRange(
                                            rowState,
                                            j,
                                            1,
                                            {value}
                                        )
                                in
                                    updated
                        )
                in
                    state & {newRow}
        )
in
    L
