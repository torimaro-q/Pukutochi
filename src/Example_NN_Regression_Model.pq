let
    // ============================================================
    // 1. Nonlinear regression dataset
    //
    // Target:
    //
    //     y = sin(x)
    //
    // x is normalized to approximately [-1, 1].
    // ============================================================

    XValues =
        List.Transform(
            {0..40},
            (i) =>
                -1.0 + 2.0 * i / 40.0
        ),

    Dataset =
        List.Transform(
            XValues,
            (xval) =>
                [
                    x = {xval},
                    t = {Number.Sin(xval * Number.PI)}
                ]
        ),

    // ============================================================
    // 2. Create neural network
    //
    //     Input : 1
    //     Hidden: 4, Tanh
    //     Hidden: 4, Tanh
    //     Output: 1, Linear
    //
    // Loss:
    //     Mean Squared Error
    // ============================================================

    Network =
        {
            PT_NN_CreateLayer(
                1,
                4,
                PT_NN_Tanh,
                PT_NN_TanhPrime
            ),
            PT_NN_CreateLayer(
                4,
                4,
                PT_NN_Tanh,
                PT_NN_TanhPrime
            ),
            PT_NN_CreateLayer(
                4,
                1,
                (v as list) as list => v,
                (v as list) as list =>
                    List.Repeat(
                        {1.0},
                        List.Count(v)
                    )
            )
        },

    // ============================================================
    // 3. Train
    // ============================================================

    Training =
        PT_NN_TrainRegression(
            Network,
            Dataset,
            300,
            0.05
        ),

    // ============================================================
    // 4. Training history
    // ============================================================

    History =
        Table.FromRecords(
            Training
        ),

    // ============================================================
    // 5. Final network
    // ============================================================

    FinalNetwork =
        Training{
            List.Count(Training) - 1
        }[net],

    // ============================================================
    // 6. Prediction
    // ============================================================

    Predictions =
        List.Transform(
            Dataset,

            (sample) =>
                let
                    Forward =
                        PT_NN_Forward(
                            FinalNetwork,
                            sample[x]
                        ),

                    Prediction =
                        Forward[output]{0},

                    Actual =
                        sample[t]{0}
                in
                    [
                        x = sample[x]{0},
                        Actual = Actual,
                        Prediction = Prediction,
                        Error = Prediction - Actual
                    ]
        ),

    Result =
        Table.FromRecords(
            Predictions
        )

in
    Result
