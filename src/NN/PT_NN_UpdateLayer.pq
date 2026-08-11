(layer as record, grad as record, lr as number) as record =>
let
    newW =
        PT_LA_MatOp(
            layer[W],
            PT_LA_Scale(
                grad[dW],
                lr
            ),
            (a, b) => a - b
        ),

    newB =
        PT_LA_MatOp(
            layer[b],
            PT_LA_Scale(
                grad[db],
                lr
            ),
            (a, b) => a - b
        )
in
    [
        W = newW,
        b = newB,
        act = layer[act],
        actPrime = layer[actPrime]
    ]
