(network as list, grads as list, lr as number) as list =>
List.Transform(
    List.Positions(network),
    (i) =>
        PT_NN_UpdateLayer(
            network{i},
            grads{i},
            lr
        )
)
