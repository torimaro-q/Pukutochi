() as binary =>
let
    // ============================================================
    // PT_Geo_SampleCubeSTL
    //
    // Returns a small Binary STL representing a
    // 10 mm ~ 10 mm ~ 10 mm cube.
    //
    // This function exists only to provide deterministic sample
    // geometry for PT_Geo examples and tests.
    //
    // Expected geometry:
    //
    //     TriangleCount = 12
    //     Width         = 10 mm
    //     Length        = 10 mm
    //     Height        = 10 mm
    //     SurfaceArea   = 600 mm^2
    //     Volume        = 1000 mm^3
    //
    // Binary STL layout:
    //
    //     Header              80 bytes
    //     Triangle count       4 bytes
    //     Triangle records    50 bytes ~ 12
    // ============================================================
    // ============================================================
    // IEEE 754 Float32 byte representations used by this sample.
    //
    // The cube only requires:
    //
    //     -1.0
    //      0.0
    //      1.0
    //     10.0
    //
    // Values are stored little-endian.
    // ============================================================

    F =
        (value as number) as list =>
        if value = -1.0 then
            {0, 0, 128, 191}
        else if value = 0.0 then
            {0, 0, 0, 0}
        else if value = 1.0 then
            {0, 0, 128, 63}
        else if value = 10.0 then
            {0, 0, 32, 65}
        else
            error "PT_Geo_SampleCubeSTL supports only -1, 0, 1 and 10.",
    I16 =
        (value as number) as list =>
        {
            Number.Mod(value, 256),
            Number.IntegerDivide(value, 256)
        },

    I32 =
        (value as number) as list =>
        {
            Number.Mod(value, 256),
            Number.Mod(
                Number.IntegerDivide(value, 256),
                256
            ),
            Number.Mod(
                Number.IntegerDivide(value, 65536),
                256
            ),
            Number.Mod(
                Number.IntegerDivide(value, 16777216),
                256
            )
        },

    // ============================================================
    // Encode one Binary STL triangle.
    // ============================================================
    Triangle =
        (
            normal as list,
            a as list,
            b as list,
            c as list
        ) as list =>
        List.Combine(
            {
                F(normal{0}),
                F(normal{1}),
                F(normal{2}),

                F(a{0}),
                F(a{1}),
                F(a{2}),

                F(b{0}),
                F(b{1}),
                F(b{2}),

                F(c{0}),
                F(c{1}),
                F(c{2}),

                I16(0)
            }
        ),
    // ============================================================
    // Cube vertices.
    //
    // 0 = (0,  0,  0)
    // 1 = (10, 0,  0)
    // 2 = (10, 10, 0)
    // 3 = (0,  10, 0)
    // 4 = (0,  0,  10)
    // 5 = (10, 0,  10)
    // 6 = (10, 10, 10)
    // 7 = (0,  10, 10)
    // ============================================================
    V0 = {0.0,  0.0,  0.0},
    V1 = {10.0, 0.0,  0.0},
    V2 = {10.0, 10.0, 0.0},
    V3 = {0.0,  10.0, 0.0},
    V4 = {0.0,  0.0,  10.0},
    V5 = {10.0, 0.0,  10.0},
    V6 = {10.0, 10.0, 10.0},
    V7 = {0.0,  10.0, 10.0},
    // ============================================================
    // Two triangles per face.
    //
    // Winding order gives outward-facing normals.
    // ============================================================
    Triangles =
        {
            // Bottom
            [
                n = {0.0, 0.0, -1.0},
                a = V0,
                b = V2,
                c = V1
            ],
            [
                n = {0.0, 0.0, -1.0},
                a = V0,
                b = V3,
                c = V2
            ],

            // Top
            [
                n = {0.0, 0.0, 1.0},
                a = V4,
                b = V5,
                c = V6
            ],
            [
                n = {0.0, 0.0, 1.0},
                a = V4,
                b = V6,
                c = V7
            ],

            // Front
            [
                n = {0.0, -1.0, 0.0},
                a = V0,
                b = V1,
                c = V5
            ],
            [
                n = {0.0, -1.0, 0.0},
                a = V0,
                b = V5,
                c = V4
            ],

            // Back
            [
                n = {0.0, 1.0, 0.0},
                a = V3,
                b = V7,
                c = V6
            ],
            [
                n = {0.0, 1.0, 0.0},
                a = V3,
                b = V6,
                c = V2
            ],

            // Left
            [
                n = {-1.0, 0.0, 0.0},
                a = V0,
                b = V4,
                c = V7
            ],
            [
                n = {-1.0, 0.0, 0.0},
                a = V0,
                b = V7,
                c = V3
            ],

            // Right
            [
                n = {1.0, 0.0, 0.0},
                a = V1,
                b = V2,
                c = V6
            ],
            [
                n = {1.0, 0.0, 0.0},
                a = V1,
                b = V6,
                c = V5
            ]
        },
    // ============================================================
    // Binary STL header.
    // ============================================================
    Header =
        List.Repeat(
            {0},
            80
        ),
    TriangleCount =
        I32(
            List.Count(Triangles)
        ),
    TriangleData =
        List.Combine(
            List.Transform(
                Triangles,
                each
                    Triangle(
                        _[n],
                        _[a],
                        _[b],
                        _[c]
                    )
            )
        ),
    Bytes =
        Header
        &
        TriangleCount
        &
        TriangleData

in
    Binary.FromList(Bytes)
