(network as list, dataset as list, epochs as number, lr as number) as list =>
List.Buffer(
    List.Generate(
        () =>
            [
                epoch = 0,
                net = network,
                loss = null
            ],

        each
            [epoch] < epochs,

        each
            let
                result =
                    PT_NN_TrainClassificationOneEpoch(
                        [net],
                        dataset,
                        lr
                    ),

                net =
                    List.Buffer(
                        List.Transform(
                            result[network],

                            (layer) =>
                                [
                                    W =
                                        List.Buffer(
                                            List.Transform(
                                                layer[W],
                                                each List.Buffer(_)
                                            )
                                        ),

                                    b =
                                        List.Buffer(layer[b]),

                                    act =
                                        layer[act],

                                    actPrime =
                                        layer[actPrime]
                                ]
                        )
                    )
            in
                [
                    epoch = [epoch] + 1,
                    net = net,
                    loss = result[loss]
                ]
    )
)
