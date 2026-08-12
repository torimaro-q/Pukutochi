let
    bmp_url  = "https://raw.githubusercontent.com/torimaro-q/Pukutochi/refs/heads/main/pic/Parrots.bmp",
    test_bmp = Binary.Buffer(Web.Contents(bmp_url)),
    Image    = PT_Img_ReadBMP(test_bmp),

    Gray =
        PT_Img_ToGray(
            Image
        ),

    Filter =
        {
            0,  1,  0,
            1, -4,  1,
            0,  1,  0
        },

    Convolved =
        PT_Img_Convolve(
            Gray,
            Filter
        ),

    Clamped =
        PT_Img_Clamp(
            Convolved
        ),

    Result =
        PT_Img_ToTable(
            Clamped
        )
in
    Result
