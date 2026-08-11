(n as number) as list =>
List.Transform(
    {1..n},
    each
        (Number.Random() * 2.0 - 1.0) * 0.1
)
