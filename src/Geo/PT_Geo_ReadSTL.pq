(stl as binary) as list =>
let
    DataStart =
        Binary.Range(
            stl,
            84
        ),

    TriangleFormat =
        BinaryFormat.Record(
            [
                NormalX =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                NormalY =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                NormalZ =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                V1X =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                V1Y =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                V1Z =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                V2X =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                V2Y =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                V2Z =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                V3X =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                V3Y =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                V3Z =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.Single,
                        ByteOrder.LittleEndian
                    ),

                AttributeByteCount =
                    BinaryFormat.ByteOrder(
                        BinaryFormat.SignedInteger16,
                        ByteOrder.LittleEndian
                    )
            ]
        ),

    RawTriangles =
        BinaryFormat.List(
            TriangleFormat
        )(DataStart),

    Mesh =
        List.Buffer(
            List.Transform(
                RawTriangles,
                (triangle) =>
                    [
                        Normal =
                            {
                                triangle[NormalX],
                                triangle[NormalY],
                                triangle[NormalZ]
                            },

                        A =
                            {
                                triangle[V1X],
                                triangle[V1Y],
                                triangle[V1Z]
                            },

                        B =
                            {
                                triangle[V2X],
                                triangle[V2Y],
                                triangle[V2Z]
                            },

                        C =
                            {
                                triangle[V3X],
                                triangle[V3Y],
                                triangle[V3Z]
                            }
                    ]
            )
        )
in
    Mesh
