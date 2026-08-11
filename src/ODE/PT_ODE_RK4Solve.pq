(f as function, h as number, steps as number, initial as list) as list =>
let
    sequence =
        List.Generate(
            () =>
                [
                    step = 0,
                    t = 0.0,
                    x = initial
                ],

            each
                [step] <= steps,

            each
                [
                    step = [step] + 1,

                    t =
                        [t] + h,

                    x =
                        PT_ODE_RK4Step(
                            f,
                            [x],
                            h
                        )
                ]
        )
in
    List.Buffer(sequence)
