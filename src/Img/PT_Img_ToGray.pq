(pixels as list) as list =>
let
    Buffer =
        List.Buffer(
            pixels
        ),

    Result =
        List.Transform(
            Buffer,

            (pixel) =>
                let
                    Gray =
                        0.299 * pixel[R]
                        + 0.587 * pixel[G]
                        + 0.114 * pixel[B]
                in
                    [
                        Row = pixel[Row],
                        Column = pixel[Column],
                        Val = Gray
                    ]
        )
in
    List.Buffer(Result)
