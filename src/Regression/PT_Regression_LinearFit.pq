(Source as table, TargetColumnName as text) as record =>
let
    Design =
        PT_Regression_DesignMatrix(
            Source,
            TargetColumnName
        ),

    Coefficients =
        PT_Regression_NormalEquation(
            Design[X],
            Design[y]
        )
in
    [
        coefficients = Coefficients,
        columns = Design[columns]
    ]
