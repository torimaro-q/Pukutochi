(
    inputSize as number,
    outputSize as number,
    act as function,
    actPrime as nullable function
) as record =>
[
    W =
        PT_NN_RandomMatrix(
            outputSize,
            inputSize
        ),

    b =
        PT_NN_RandomVector(
            outputSize
        ),

    act = act,
    actPrime = actPrime
]
