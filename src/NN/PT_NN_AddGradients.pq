(g1 as list, g2 as list) as list =>
let
    n = List.Count(g1),

    result = List.Transform({0..n-1},(i) =>
                let
                    a = g1{i},
                    b = g2{i},
                    aW = a[dW],
                    bW = b[dW],
                    wRows = List.Transform({0..List.Count(aW)-1},(r) =>
                                let
                                    ar = aW{r},
                                    br = bW{r}
                                in
                                    List.Transform(
                                        {0..List.Count(ar)-1},
                                        (c) =>
                                            ar{c} + br{c}
                                    )
                        ),
                    ab = a[db],
                    bb = b[db],
                    newB = List.Transform({0..List.Count(ab)-1},(j) => ab{j} + bb{j})
                in
                    [
                        dW = wRows,
                        db = newB
                    ]
            )
        
in
    result
