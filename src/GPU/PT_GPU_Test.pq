(src as text,w as number,h as number,t as number,dt as number,init as text, optional outclmname as text) as table =>
let    
    //-----------------------------debug---------------------------------
    /*
    w = 128,h = 128,t = 10,dt = 0.1,init = "0,0,0,1",outclmname = "c0",
    src = "
precision highp float;
uniform float time;
void main()
{
    gl_FragColor = vec4(time / 10.0,0.0,0.0,1.0);
}
",
    */
    //-----------------------------debug---------------------------------
    ot = if outclmname = null then "c0" else outclmname,  
    endpoint = "https://torimaro-q.github.io/Pukutochi/gpu/test.html",
    Url =
        endpoint
        & "?width=" & Number.ToText(w)
        & "&height=" & Number.ToText(h)
        & "&totalTime=" & Number.ToText(t)
        & "&dt=" & Number.ToText(dt)
        & "&initial=" & Uri.EscapeDataString(init)
        & "&shader=" & Uri.EscapeDataString(src),

    Html = Web.BrowserContents(Url),
    RawJsonL =
        try
            "[" & Text.Split(Text.Split(Html,"""rows"":["){1},"]}</div>"){0} & "]"
        otherwise
            "[]",
    JsonL       = Json.Document(RawJsonL,65001),
    Raw         = Table.FromRecords(JsonL),
    Transformed = Table.TransformColumnTypes(Raw,{{"t", Int64.Type}, {"x", Int64.Type}, {"y", Int64.Type}, {ot, type number}}),
    result      = Table.SelectColumns(Transformed,{"t", "x", "y", ot})
in
    result