(A as list, s as number) as list =>
if List.IsEmpty(A) then
    {}
else if Value.Is(A{0}, type list) then
    List.Transform(
        A,
        each
            List.Transform(
                _,
                (x) => x * s
            )
    )
else
    List.Transform(
        A,
        each _ * s
    )
