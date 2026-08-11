(v as list) as list =>
List.Transform(
    v,
    each
        if _ > 0 then
            _
        else
            0
)
