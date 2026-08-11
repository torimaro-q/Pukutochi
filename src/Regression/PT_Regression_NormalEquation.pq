(X as list, y as list) as list =>
let
    Xbuf = List.Buffer(X),
    ybuf = List.Buffer(y),

    rowCount =
        List.Count(Xbuf),

    featureCount =
        List.Count(Xbuf{0}),

    FeaturePositions =
        {0..featureCount-1},

    XTX =
        List.Buffer(
            List.Transform(
                FeaturePositions,
                (i) =>
                    List.Transform(
                        FeaturePositions,
                        (j) =>
                            List.Sum(
                                List.Transform(
                                    {0..rowCount-1},
                                    (k) =>
                                        Xbuf{k}{i}
                                        * Xbuf{k}{j}
                                )
                            )
                    )
            )
        ),

    XTy =
        List.Buffer(
            List.Transform(
                FeaturePositions,
                (i) =>
                    List.Sum(
                        List.Transform(
                            {0..rowCount-1},
                            (k) =>
                                Xbuf{k}{i}
                                * ybuf{k}
                        )
                    )
            )
        ),

    L =
        PT_LA_Cholesky(XTX),

    z =
        PT_LA_ForwardSub(
            L,
            XTy
        ),

    beta =
        PT_LA_BackSub(
            L,
            z
        )
in
    beta
