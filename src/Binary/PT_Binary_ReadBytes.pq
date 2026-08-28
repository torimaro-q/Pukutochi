(data as binary, optional count as number) as list =>
let
    Limit =
        if count = null then
            1000
        else
            Number.RoundDown(count),

    DataLength =
        Binary.Length(data),

    ActualCount =
        if DataLength < Limit then
            DataLength
        else
            Limit,

    Result =
        if ActualCount <= 0 then
            {}
        else
            Binary.ToList(
                Binary.Range(
                    data,
                    0,
                    ActualCount
                )
            )
in
    List.Buffer(Result)
