(v as list) as list =>
let
    m =
        List.Max(v),

    expValues =
        List.Transform(
            v,
            each Number.Exp(_ - m)
        ),

    sumExp =
        List.Sum(expValues)
in
    List.Transform(
        expValues,
        each _ / sumExp
    )
