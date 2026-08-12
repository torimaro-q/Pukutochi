(Mesh as list) as record =>
let
    Triangles =
        List.Buffer(Mesh),

    TriangleCount =
        List.Count(Triangles),

    // ------------------------------------------------------------
    // Vertices
    // ------------------------------------------------------------

    Vertices =
        List.Buffer(
            List.Combine(
                List.Transform(
                    Triangles,
                    each
                        {
                            _[A],
                            _[B],
                            _[C]
                        }
                )
            )
        ),

    VertexCount =
        List.Count(Vertices),

    Xs =
        List.Transform(
            Vertices,
            each _{0}
        ),

    Ys =
        List.Transform(
            Vertices,
            each _{1}
        ),

    Zs =
        List.Transform(
            Vertices,
            each _{2}
        ),

    MinX =
        List.Min(Xs),

    MaxX =
        List.Max(Xs),

    MinY =
        List.Min(Ys),

    MaxY =
        List.Max(Ys),

    MinZ =
        List.Min(Zs),

    MaxZ =
        List.Max(Zs),

    Width =
        MaxX - MinX,

    Length =
        MaxY - MinY,

    Height =
        MaxZ - MinZ,

    // ------------------------------------------------------------
    // Surface area and volume
    // ------------------------------------------------------------

    TriangleGeometry =
        List.Transform(
            Triangles,
            (triangle) =>
                let
                    A = triangle[A],
                    B = triangle[B],
                    C = triangle[C],

                    AB =
                        {
                            B{0} - A{0},
                            B{1} - A{1},
                            B{2} - A{2}
                        },

                    AC =
                        {
                            C{0} - A{0},
                            C{1} - A{1},
                            C{2} - A{2}
                        },

                    Cross =
                        {
                            AB{1} * AC{2}
                                - AB{2} * AC{1},

                            AB{2} * AC{0}
                                - AB{0} * AC{2},

                            AB{0} * AC{1}
                                - AB{1} * AC{0}
                        },

                    SurfaceArea =
                        0.5
                        *
                        Number.Sqrt(
                            Cross{0} * Cross{0}
                            +
                            Cross{1} * Cross{1}
                            +
                            Cross{2} * Cross{2}
                        ),

                    SignedVolume =
                        (
                            A{0}
                            *
                            (
                                B{1} * C{2}
                                -
                                B{2} * C{1}
                            )

                            -

                            A{1}
                            *
                            (
                                B{0} * C{2}
                                -
                                B{2} * C{0}
                            )

                            +

                            A{2}
                            *
                            (
                                B{0} * C{1}
                                -
                                B{1} * C{0}
                            )
                        )
                        / 6.0
                in
                    [
                        SurfaceArea = SurfaceArea,
                        SignedVolume = SignedVolume
                    ]
        ),

    SurfaceArea =
        List.Sum(
            List.Transform(
                TriangleGeometry,
                each _[SurfaceArea]
            )
        ),

    Volume =
        Number.Abs(
            List.Sum(
                List.Transform(
                    TriangleGeometry,
                    each _[SignedVolume]
                )
            )
        )
in
    [
        TriangleCount = TriangleCount,
        VertexCount = VertexCount,

        MinX = MinX,
        MaxX = MaxX,

        MinY = MinY,
        MaxY = MaxY,

        MinZ = MinZ,
        MaxZ = MaxZ,

        Width = Width,
        Length = Length,
        Height = Height,

        SurfaceArea = SurfaceArea,
        Volume = Volume
    ]
