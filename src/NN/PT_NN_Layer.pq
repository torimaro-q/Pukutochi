(x as list, layer as record) as record =>
let
    z =
        PT_LA_MatOp(
            PT_LA_MatVec(
                layer[W],
                x
            ),
            layer[b],
            (a, b) => a + b
        ),

    a =
        layer[act](z)
in
    [
        output = a,

        cache =
            [
                input = x,
                z = z,
                // a = a,
                W = layer[W],
                b = layer[b],
                //act = layer[act],
                actPrime = layer[actPrime]
            ]
    ]
