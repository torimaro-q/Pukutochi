(bmp as binary) as list =>
let
    // ============================================================
    // BMP / DIB header
    // ============================================================

    UInt16LE =
        BinaryFormat.ByteOrder(
            BinaryFormat.UnsignedInteger16,
            ByteOrder.LittleEndian
        ),

    UInt32LE =
        BinaryFormat.ByteOrder(
            BinaryFormat.UnsignedInteger32,
            ByteOrder.LittleEndian
        ),

    Int32LE =
        BinaryFormat.ByteOrder(
            BinaryFormat.SignedInteger32,
            ByteOrder.LittleEndian
        ),

    // Pixel data offset is at byte 10 of BMP file header
    PixelOffset =
        UInt32LE(
            Binary.Range(
                bmp,
                10,
                4
            )
        ),

    // DIB header
    DIBSize =
        UInt32LE(
            Binary.Range(
                bmp,
                14,
                4
            )
        ),

    Width =
        Int32LE(
            Binary.Range(
                bmp,
                18,
                4
            )
        ),

    RawHeight =
        Int32LE(
            Binary.Range(
                bmp,
                22,
                4
            )
        ),

    BitCount =
        UInt16LE(
            Binary.Range(
                bmp,
                28,
                2
            )
        ),

    Height =
        Number.Abs(RawHeight),

    TopDown =
        RawHeight < 0,

    BytesPerPixel =
        BitCount / 8,

    // ============================================================
    // Supported formats
    //
    // 24-bit = BGR
    // 32-bit = BGRA
    // ============================================================

    ValidBitDepth =
        BitCount = 24
        or BitCount = 32,

    Checked =
        if not ValidBitDepth then
            error
                "PT_Img_ReadBMP supports only 24-bit and 32-bit BMP."
        else
            true,

    // BMP rows are aligned to 4-byte boundaries
    RowPadding =
        Number.Mod(
            4 - Number.Mod(
                Width * BytesPerPixel,
                4
            ),
            4
        ),

    RowSize =
        Width * BytesPerPixel
        + RowPadding,

    PixelData =
        Binary.Range(
            bmp,
            PixelOffset
        ),

    Buffer =
        List.Buffer(
            Binary.ToList(
                PixelData
            )
        ),

    // ============================================================
    // Read one pixel
    // ============================================================

    Pixels =
        List.Transform(
            {0..Width * Height - 1},

            (n) =>
                let
                    Row =
                        Number.IntegerDivide(
                            n,
                            Width
                        ),

                    Column =
                        Number.Mod(
                            n,
                            Width
                        ),

                    StorageRow =
                        if TopDown then
                            Row
                        else
                            Height - 1 - Row,

                    Index =
                        StorageRow * RowSize
                        + Column * BytesPerPixel,

                    B =
                        Buffer{Index},

                    G =
                        Buffer{Index + 1},

                    R =
                        Buffer{Index + 2},

                    A =
                        if BitCount = 32 then
                            Buffer{Index + 3}
                        else
                            255
                in
                    [
                        Row = Row,
                        Column = Column,
                        R = R,
                        G = G,
                        B = B,
                        A = A,
                        Val = 0.0
                    ]
        )
in
    List.Buffer(Pixels)
