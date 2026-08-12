(Analysis as record) as table =>
#table(
    {
        "TriangleCount",
        "VertexCount",

        "Width[mm]",
        "Length[mm]",
        "Height[mm]",

        "SurfaceArea[mm^2]",
        "Volume[mm^3]"
    },
    {
        {
            Analysis[TriangleCount],
            Analysis[VertexCount],

            Analysis[Width],
            Analysis[Length],
            Analysis[Height],

            Analysis[SurfaceArea],
            Analysis[Volume]
        }
    }
)
