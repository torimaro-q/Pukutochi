// TableToMarkdown
// Converts a Power Query table to Markdown table format.
// References:
// https://qiita.com/tanuki_phoenix/items/be7a2cfa4f7cf40d2967

(table as table) as text =>
let
    EscapeMarkdown = (value as any) as text =>
        let
            textValue = if value = null then "" else Text.From(value),
            escaped   = Text.Replace(Text.Replace(Text.Replace(textValue,"|","\|"),"#(cr)#(lf)","<br>"),"#(lf)","<br>"),
            result    = Text.Replace(escaped,"#(cr)","<br>")
        in
            result,
    Headers      = List.Transform(Table.ColumnNames(table),each EscapeMarkdown(_)),
    HeaderRow    = "| " & Text.Combine(Headers, " | ") & " |",
    SeparatorRow = "| " & Text.Combine(List.Repeat({"---"}, List.Count(Headers))," | ") & " |",
    DataRows     = List.Transform(Table.ToRows(table), each "| " & Text.Combine(List.Transform(_, EscapeMarkdown)," | ") & " |"),
    Result       = Text.Combine({HeaderRow, SeparatorRow} & DataRows,"#(lf)")
in
    Result
