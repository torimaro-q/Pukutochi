(Source as table, TargetColumnName as text) as record =>
let
    TableData =
        Table.Buffer(Source),

    ColumnNames =
        Table.ColumnNames(TableData),

    NumericColumns =
        List.Buffer(
            List.Select(
                ColumnNames,
                (col) =>
                    Value.Is(
                        Table.Column(TableData, col){0},
                        type number
                    )
            )
        ),

    XColumns =
        List.Buffer(
            List.RemoveItems(
                NumericColumns,
                {TargetColumnName}
            )
        ),

    y =
        List.Buffer(
            Table.Column(
                TableData,
                TargetColumnName
            )
        ),

    Intercept =
        List.Repeat(
            {1.0},
            Table.RowCount(TableData)
        ),

    XColumnsData =
        List.Transform(
            XColumns,
            (col) =>
                List.Buffer(
                    Table.Column(
                        TableData,
                        col
                    )
                )
        ),

    Columns =
        List.Buffer(
            {Intercept} & XColumnsData
        ),

    RowPositions =
        {0..Table.RowCount(TableData)-1},

    X =
        List.Buffer(
            List.Transform(
                RowPositions,
                (i) =>
                    List.Transform(
                        Columns,
                        each _{i}
                    )
            )
        ),

    FeatureNames =
        List.Buffer(
            {"Intercept"} & XColumns
        )
in
    [
        X = X,
        y = y,
        columns = FeatureNames
    ]
