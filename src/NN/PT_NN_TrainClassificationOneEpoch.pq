(network as list, dataset as list, lr as number) as record =>
let
    data =
        List.Buffer(dataset),

    net =
        List.Buffer(network),

    init =
        [
            loss = 0.0,

            grads =
                List.Buffer(
                    List.Transform(
                        net,
                        each
                            [
                                dW =
                                    List.Buffer(
                                        List.Transform(
                                            _[W],
                                            each
                                                List.Buffer(
                                                    List.Transform(
                                                        _,
                                                        each 0.0
                                                    )
                                                )
                                        )
                                    ),

                                db =
                                    List.Buffer(
                                        List.Transform(
                                            _[b],
                                            each 0.0
                                        )
                                    )
                            ]
                    )
                )
        ],

    accumulated =
        List.Accumulate(
            data,
            init,

            (state, sample) =>
                let
                    x =
                        List.Buffer(sample[x]),

                    t =
                        List.Buffer(sample[t]),

                    forward =
                        PT_NN_Forward(
                            net,
                            x
                        ),

                    y =
                        List.Buffer(
                            forward[output]
                        ),

                    loss =
                        PT_NN_CrossEntropy(
                            y,
                            t
                        ),

                    delta =
                        List.Buffer(
                            List.Transform(
                                List.Positions(y),
                                (i) =>
                                    y{i} - t{i}
                            )
                        ),

                    backward =
                        PT_NN_Backward(
                            forward[cache],
                            delta
                        ),

                    newGrads =
                        PT_NN_AddGradients(
                            state[grads],
                            backward[grads]
                        )
                in
                    [
                        loss =
                            state[loss] + loss,

                        grads =
                            List.Buffer(newGrads)
                    ]
        ),

    meanGrads =
        List.Buffer(
            PT_NN_ScaleGradients(
                accumulated[grads],
                1 / List.Count(data)
            )
        ),

    newNetwork =
        List.Transform(
            PT_NN_UpdateNetwork(
                net,
                meanGrads,
                lr
            ),

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
in
    [
        network = newNetwork,

        loss =
            accumulated[loss]
            / List.Count(data)
    ]
