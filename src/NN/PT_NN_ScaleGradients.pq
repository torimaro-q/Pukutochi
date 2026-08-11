(grads as list, s as number) as list =>
List.Transform(
    grads,
    (g) =>
        [
            dW =
                PT_LA_Scale(
                    g[dW],
                    s
                ),

            db =
                PT_LA_Scale(
                    g[db],
                    s
                )
        ]
)
