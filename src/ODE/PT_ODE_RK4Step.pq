(f as function, x as list, h as number) as list =>
let
    n =
        List.Count(x),

    k1 =
        f(x),

    x2 =
        List.Transform(
            {0..n-1},
            (i) =>
                x{i}
                + (h / 2.0) * k1{i}
        ),

    k2 =
        f(x2),

    x3 =
        List.Transform(
            {0..n-1},
            (i) =>
                x{i}
                + (h / 2.0) * k2{i}
        ),

    k3 =
        f(x3),

    x4 =
        List.Transform(
            {0..n-1},
            (i) =>
                x{i}
                + h * k3{i}
        ),

    k4 =
        f(x4),

    next =
        List.Transform(
            {0..n-1},
            (i) =>
                x{i}
                + (h / 6.0)
                * (
                    k1{i}
                    + 2.0 * k2{i}
                    + 2.0 * k3{i}
                    + k4{i}
                )
        )
in
    List.Buffer(next)
