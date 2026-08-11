(A as list, B as list, op as function) as list =>
if List.IsEmpty(A) then
    {}
else if Value.Is(A{0}, type list) then
    List.Transform(
        List.Positions(A),
        (i) =>
            let
                a = A{i},
                b = B{i}
            in
                List.Transform(
                    List.Positions(a),
                    (j) => op(a{j}, b{j})
                )
    )
else
    List.Transform(
        List.Positions(A),
        (i) => op(A{i}, B{i})
    )
