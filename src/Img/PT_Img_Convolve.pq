(pixels as list, filter as list) as list =>
let
    P =
        List.Buffer(
            pixels
        ),

    F =
        List.Buffer(
            filter
        ),

    PixelCount =
        List.Count(P),

    FilterCount =
        List.Count(F),

    // ============================================================
    // Image dimensions
    // ============================================================

    MaxColumn =
        List.Max(
            List.Transform(
                P,
                each [Column]
            )
        ),

    MaxRow =
        List.Max(
            List.Transform(
                P,
                each [Row]
            )
        ),

    Width =
        MaxColumn + 1,

    Height =
        MaxRow + 1,

    // ============================================================
    // Kernel dimensions
    //
    // Filter is supplied as a flat list.
    //
    // Example 3x3:
    //
    // {0,1,0,
    //  1,-4,1,
    //  0,1,0}
    // ============================================================

    KernelSizeFloat =
        Number.Sqrt(
            FilterCount
        ),

    KernelSize =
        Number.RoundDown(
            KernelSizeFloat
        ),

    ValidKernel =
        KernelSize * KernelSize = FilterCount
        and Number.Mod(KernelSize, 2) = 1,

    Checked =
        if not ValidKernel then
            error
                "PT_Img_Convolve requires an odd square kernel."
        else
            true,

    Radius =
        Number.IntegerDivide(
            KernelSize,
            2
        ),

    Values =
        List.Buffer(
            List.Transform(
                P,
                each [Val]
            )
        ),

    // ============================================================
    // Convolution
    // ============================================================

    Result =
        List.Transform(
            {0..PixelCount - 1},

            (i) =>
                let
                    Pixel =
                        P{i},

                    Row =
                        Pixel[Row],

                    Column =
                        Pixel[Column],

                    KernelPositions =
                        {0..FilterCount - 1},

                    Sum =
                        List.Sum(
                            List.Transform(
                                KernelPositions,

                                (k) =>
                                    let
                                        KernelRow =
                                            Number.IntegerDivide(
                                                k,
                                                KernelSize
                                            ),

                                        KernelColumn =
                                            Number.Mod(
                                                k,
                                                KernelSize
                                            ),

                                        ImageRow =
                                            Row
                                            + KernelRow
                                            - Radius,

                                        ImageColumn =
                                            Column
                                            + KernelColumn
                                            - Radius,

                                        Inside =
                                            ImageRow >= 0
                                            and ImageRow < Height
                                            and ImageColumn >= 0
                                            and ImageColumn < Width,

                                        ImageIndex =
                                            if Inside then
                                                ImageRow * Width
                                                + ImageColumn
                                            else
                                                0,

                                        PixelValue =
                                            if Inside then
                                                Values{ImageIndex}
                                            else
                                                0.0
                                    in
                                        F{k} * PixelValue
                            )
                        )
                in
                    [
                        Row = Row,
                        Column = Column,
                        Val = Sum
                    ]
        )
in
    List.Buffer(Result)
