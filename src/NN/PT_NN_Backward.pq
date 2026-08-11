(cacheList as list, delta as list) as record =>
let
    reversed =
        List.Reverse(cacheList),

    result =
        List.Accumulate(
            reversed,

            [
                delta = delta,
                grads = {}
            ],

            (state, cache) =>
                let
                    grad =
                        PT_NN_LayerBackward(
                            cache,
                            state[delta]
                        )
                in
                    [
                        delta = grad[dx],

                        grads =
                            {grad}
                            &
                            state[grads]
                    ]
        )
in
    [
        delta = result[delta],
        grads = result[grads]
    ]
