(data as binary) as record =>
let
    Bytes =
        PT_Binary_ReadBytes(
            data,
            16
        ),

    HasPrefix =
        (signature as list) as logical =>
        let
            n =
                List.Count(signature),

            enough =
                List.Count(Bytes) >= n,

            match =
                if not enough then
                    false
                else
                    List.AllTrue(
                        List.Transform(
                            {0..n-1},
                            (i) =>
                                Bytes{i}
                                =
                                signature{i}
                        )
                    )
        in
            match,

    Candidates =
        {
            [
                Type = "PNG",
                Signature = {137, 80, 78, 71, 13, 10, 26, 10}
            ],

            [
                Type = "ZIP",
                Signature = {80, 75, 3, 4}
            ],

            [
                Type = "ZIP",
                Signature = {80, 75, 5, 6}
            ],

            [
                Type = "ZIP",
                Signature = {80, 75, 7, 8}
            ],

            [
                Type = "JPEG",
                Signature = {255, 216, 255}
            ],

            [
                Type = "BMP",
                Signature = {66, 77}
            ],

            [
                Type = "GIF",
                Signature = {71, 73, 70, 56}
            ],

            [
                Type = "PDF",
                Signature = {37, 80, 68, 70}
            ],

            [
                Type = "GZIP",
                Signature = {31, 139}
            ],

            [
                Type = "RIFF",
                Signature = {82, 73, 70, 70}
            ]
        },

    Matches =
        List.Select(
            Candidates,
            each HasPrefix(_[Signature])
        ),

    Result =
        if List.IsEmpty(Matches) then
            [
                Type = "Unknown",
                SignatureLength = 0,
                Signature = {}
            ]
        else
            let
                Match =
                    Matches{0}
            in
                [
                    Type = Match[Type],
                    SignatureLength =
                        List.Count(
                            Match[Signature]
                        ),
                    Signature =
                        Match[Signature]
                ]
in
    Result
