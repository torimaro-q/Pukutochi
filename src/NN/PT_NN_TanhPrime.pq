(v as list) as list =>
List.Transform(
    v,
    each
        let
            e = Number.Tanh(_)
        in
            1.0 - e * e
)
