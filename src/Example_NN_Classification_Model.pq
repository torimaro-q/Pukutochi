let
    // ============================================================
    // 1. XOR classification dataset
    //
    //     x1  x2  -> class
    //
    //      0   0  -> 0
    //      0   1  -> 1
    //      1   0  -> 1
    //      1   1  -> 0
    //
    // Target is one-hot encoded.
    // ============================================================

    Dataset =
        {
            [x = {0.0, 0.0}, t = {1.0, 0.0}],
            [x = {0.0, 1.0}, t = {0.0, 1.0}],
            [x = {1.0, 0.0}, t = {0.0, 1.0}],
            [x = {1.0, 1.0}, t = {1.0, 0.0}]
        },

    // ============================================================
    // 2. Create neural network
    //
    //     Input : 2
    //     Hidden: 4, Tanh
    //     Output: 2, Softmax
    //
    // Loss:
    //     Cross Entropy
    // ============================================================

    Network =
        {
            PT_NN_CreateLayer(
                2,
                4,
                PT_NN_Tanh,
                PT_NN_TanhPrime
            ),

            PT_NN_CreateLayer(
                4,
                2,
                PT_NN_Softmax,
                null
            )
        },

    // ============================================================
    // 3. Train
    // ============================================================

    Training =
        PT_NN_TrainClassification(
            Network,
            Dataset,
            2000,
            0.1
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
        Training{List.Count(Training) - 1}[net],

    // ============================================================
    // 6. Prediction
    // ============================================================

    Predict =
        List.Transform(
            Dataset,

            (sample) =>
                let
                    Forward =
                        PT_NN_Forward(
                            FinalNetwork,
                            sample[x]
                        ),

                    Probability =
                        Forward[output],

                    Prediction =
                        if Probability{0} >= Probability{1} then
                            0
                        else
                            1,

                    Actual =
                        if sample[t]{0} >= sample[t]{1} then
                            0
                        else
                            1
                in
                    [
                        x1 = sample[x]{0},
                        x2 = sample[x]{1},

                        Actual = Actual,

                        Probability_0 =
                            Probability{0},

                        Probability_1 =
                            Probability{1},

                        Prediction = Prediction,

                        Correct =
                            Prediction = Actual
                    ]
        ),

    Result =
        Table.FromRecords(
            Predict
        )

in
    Result
