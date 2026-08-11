(sequence as list) as table =>
let
    firstState =
        sequence{0}[x],

    fieldNames =
        List.Transform(
            {1..List.Count(firstState)},
            each "x" & Text.From(_)
        ),

    Source =
        Table.FromRecords(
            sequence
        ),

    AddRecord =
        Table.TransformColumns(
            Source,
            {
                "x",
                each
                    Record.FromList(
                        _,
                        fieldNames
                    )
            }
        ),

    Expanded =
        Table.ExpandRecordColumn(
            AddRecord,
            "x",
            fieldNames,
            fieldNames
        ),

    Result =
        Table.TransformColumnTypes(
            Expanded,
            {
                {"step", Int64.Type},
                {"t", type number}
            }
            &
            List.Transform(
                fieldNames,
                each {_, type number}
            )
        )
in
    Result
