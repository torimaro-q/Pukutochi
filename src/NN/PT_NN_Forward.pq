(network as list, x as list) as record =>
let
    state =
        List.Accumulate(
            network,

            [
                output = x,
                cache = {}
            ],

            (state, layer) =>
                let
                    result =
                        PT_NN_Layer(
                            state[output],
                            layer
                        )
                in
                    [
                        output = result[output],

                        cache =
                            state[cache]
                            &
                            {
                                result[cache]
                            }
                    ]
        )
in
    state
