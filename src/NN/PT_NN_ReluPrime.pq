(v as list) as list =>
List.Transform(
    v,
    each
        if _ > 0 then
            1
        else
            0
)
