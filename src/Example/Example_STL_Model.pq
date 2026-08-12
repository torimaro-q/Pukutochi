let
    // ============================================================
    // Example_STL_Analyze
    // Sample:
    //     10 mm Å~ 10 mm Å~ 10 mm cube
    //
    // Expected:
    //     TriangleCount = 12
    //     Width         = 10 mm
    //     Length        = 10 mm
    //     Height        = 10 mm
    //     SurfaceArea   = 600 mm^2
    //     Volume        = 1000 mm^3
    //     Volume -> Weight -> Cost
    // ============================================================

    // ============================================================
    // 1. Get sample STL
    //
    // PT_Geo_SampleCubeSTL returns a deterministic
    // Binary STL representing a 10 mm cube.
    // ============================================================

    STL =
        PT_Geo_SampleCubeSTL(),


    // ============================================================
    // 2. Read STL
    //
    // Binary STL
    //     Å´
    // Mesh
    // ============================================================

    Mesh =
        PT_Geo_ReadSTL(
            STL
        ),


    // ============================================================
    // 3. Analyze geometry
    //
    // Mesh
    //     Å´
    // Geometry
    //
    // Geometry contains:
    //
    //     TriangleCount
    //     VertexCount
    //
    //     MinX / MaxX
    //     MinY / MaxY
    //     MinZ / MaxZ
    //
    //     Width
    //     Length
    //     Height
    //
    //     SurfaceArea
    //     Volume
    // ============================================================

    Geometry =
        PT_Geo_AnalyzeMesh(
            Mesh
        ),


    // ============================================================
    // 4. Material calculation
    //
    // This is Example-level logic.
    //
    // Density:
    //
    //     1.24 g/cm^3
    //
    // Volume is mm^3, so:
    //
    //     1000 mm^3 = 1 cm^3
    //
    // Weight:
    //
    //     Volume / 1000 Å~ Density
    // ============================================================

    Density =
        1.24,

    Weight =
        Geometry[Volume]
        / 1000.0
        * Density,


    // ============================================================
    // 5. Cost calculation
    //
    // Material cost:
    //
    //     3 yen / gram
    // ============================================================

    CostPerGram =
        3.0,

    Cost =
        Weight
        * CostPerGram,


    // ============================================================
    // 6. Result
    //
    // Geometry is combined with the Example-specific
    // material and cost calculations.
    // ============================================================

    Result =
        #table(
            {
                "TriangleCount",
                "VertexCount",

                "Width[mm]",
                "Length[mm]",
                "Height[mm]",

                "SurfaceArea[mm^2]",
                "Volume[mm^3]",

                "Density[g/cm^3]",
                "Weight[g]",

                "CostPerGram[yen/g]",
                "Cost[yen]"
            },
            {
                {
                    Geometry[TriangleCount],
                    Geometry[VertexCount],

                    Geometry[Width],
                    Geometry[Length],
                    Geometry[Height],

                    Geometry[SurfaceArea],
                    Geometry[Volume],

                    Density,
                    Weight,

                    CostPerGram,
                    Cost
                }
            }
        )

in
    Result
