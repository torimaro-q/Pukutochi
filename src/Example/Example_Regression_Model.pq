let
    // ============================================================
    // 1. Sample data
    //
    // True model:
    //
    //     y = 3.0 + 2.0*x1 - 1.5*x2
    //
    // ============================================================

    Source =
        #table(
            type table
            [
                x1 = number,
                x2 = number,
                y  = number
            ],
            {
                {1.0, 2.0,  2.0},
                {2.0, 1.0,  6.5},
                {3.0, 4.0,  3.0},
                {4.0, 2.0,  8.0},
                {5.0, 3.0,  8.5},
                {6.0, 1.0, 13.5},
                {7.0, 4.0, 11.0},
                {8.0, 2.0, 16.0}
            }
        ),

    // ============================================================
    // 2. Fit linear regression
    //
    //     y = beta0 + beta1*x1 + beta2*x2
    //
    // Internally:
    //
    //     X'X beta = X'y
    //
    // solved by Cholesky decomposition.
    // ============================================================

    Model =
        PT_Regression_LinearFit(
            Source,
            "y"
        ),

    // ============================================================
    // 3. Model coefficients
    // ============================================================

    Coefficients =
        Model[coefficients],

    Columns =
        Model[columns],

    CoefficientTable =
        Table.FromColumns(
            {
                Columns,
                Coefficients
            },
            {
                "Term",
                "Coefficient"
            }
        ),

    // ============================================================
    // 4. Add predictions to original data
    // ============================================================

    AddPrediction =
        Table.AddColumn(
            Source,
            "Prediction",
            each
                PT_Regression_Predict(
                    Model,
                    _
                ),
            type number
        ),

    // ============================================================
    // 5. Residual
    // ============================================================

    AddResidual =
        Table.AddColumn(
            AddPrediction,
            "Residual",
            each
                [y] - [Prediction],
            type number
        )

in
    AddResidual
