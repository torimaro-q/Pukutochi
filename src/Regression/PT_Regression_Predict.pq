(Model as record, Row as record) as number =>
let
    Columns =
        Model[columns],

    Coefficients =
        Model[coefficients],

    x =
        List.Transform(
            Columns,
            (column) =>
                if column = "Intercept" then
                    1.0
                else
                    Record.Field(
                        Row,
                        column
                    )
        )
in
    PT_LA_Dot(
        Coefficients,
        x
    )
