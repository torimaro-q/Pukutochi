(pixels as list) as table =>
let
    P =
        List.Buffer(
            pixels
        ),

    Source =
        Table.FromRecords(
            P
        ),

    Typed =
        Table.TransformColumnTypes(
            Source,
            {
                {"Row", Int64.Type},
                {"Column", Int64.Type},
                {"Val", type number}
            }
        ),

    ColumnNames =
        List.Buffer(
            List.Transform(
                List.Sort(
                    List.Distinct(
                        Typed[Column]
                    )
                ),
                each Text.From(_)
            )
        ),

    ColumnText =
        Table.TransformColumns(
            Typed,
            {
                {
                    "Column",
                    each Text.From(_),
                    type text
                }
            }
        ),

    Pivoted =
        Table.Pivot(
            ColumnText,
            ColumnNames,
            "Column",
            "Val",
            List.First
        ),

    Result =
        Table.Sort(
            Pivoted,
            {
                {"Row", Order.Ascending}
            }
        )
in
    Result
