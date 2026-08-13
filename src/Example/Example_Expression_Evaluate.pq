let
    Expressions =
        {
            "PT_LA_Dot({1, 2, 3}, {4, 5, 6})",
            "PT_LA_Dot({10, 20}, {3, 4})"
        },

    Result =
        Table.FromRecords(
            List.Transform(
                Expressions,
                (expression) =>
                    [
                        Expression = expression,
                        Result =
                            PT_Expression_Evaluate(
                                expression
                            )
                    ]
            )
        )
in
    Result
