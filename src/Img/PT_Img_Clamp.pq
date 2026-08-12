(
    pixels as list,
    optional minValue as number,
    optional maxValue as number
) as list =>
let
    Min =
        if minValue = null then
            0.0
        else
            minValue,

    Max =
        if maxValue = null then
            255.0
        else
            maxValue,

    Result =
        List.Transform(
            pixels,

            (pixel) =>
                [
                    Row = pixel[Row],
                    Column = pixel[Column],

                    Val =
                        if pixel[Val] < Min then
                            Min
                        else if pixel[Val] > Max then
                            Max
                        else
                            pixel[Val]
                ]
        )
in
    List.Buffer(Result)
