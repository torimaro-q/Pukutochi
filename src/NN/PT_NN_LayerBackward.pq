(cache as record, delta as list) as record =>
let
    x = cache[input],
    z = cache[z],
    W = cache[W],
    actPrime = cache[actPrime],

    dz =
        if actPrime = null then
            delta
        else
            PT_LA_MatOp(
                delta,
                actPrime(z),
                (a, b) => a * b
            ),

    db =
        dz,

    dx =
        PT_LA_MatVecT(
            W,
            dz
        ),

    dW =
        PT_LA_OuterProduct(
            dz,
            x
        )
in
    [
        dx = dx,
        dW = dW,
        db = db
    ]
