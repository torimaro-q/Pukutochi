(w as number,h as number,t as number,dt as number,init as record,passes as list,optional uniforms as nullable record,optional outclmname as nullable text) as table =>
let
    //PQ-GPU common runtime caller
    //debug
    /*
    w = 4,h = 4,t = 1,dt = 1,uniforms = null,outclmname = "value",
    init = [type = "constant",value = {0.1, 0, 0, 1}],
    passes = 
    {
        [
            name = "add",
            inputs =[state = "state"],
            shader = 
"
precision highp float;
uniform sampler2D state;
uniform vec2 resolution;
void main()
{
    vec2 uv = gl_FragCoord.xy / resolution;
    vec4 s = texture2D(state, uv);
    gl_FragColor = s + vec4(0.1, 0.0, 0.0, 0.0);
}              
",
            output = "state"
        ],
        [
            name = "multiply",
            inputs = [state = "state"],
            shader = 
"
precision highp float;
uniform sampler2D state;
uniform vec2 resolution;
void main()
{
    vec2 uv = gl_FragCoord.xy / resolution;
    vec4 s = texture2D(state, uv);
    gl_FragColor = s * vec4(2.0, 1.0, 1.0, 1.0);
}              
",
            output = "state"
        ]
    },
    */
    /*------------------------------------------------------------
    Runtime configuration
    ------------------------------------------------------------*/
    Endpoint = "https://torimaro-q.github.io/Pukutochi/gpu/v1.html",
    OutputColumn = if outclmname = null then "c0" else outclmname,
    Config =
        [
            version  = 1,
            grid     = [width = w,height = h],
            time     = [total = t,dt = dt],
            uniforms = if uniforms = null then [] else uniforms,
            fields   = [state = [initial = init]],
            passes   = passes,
            output   = [field = "state"]
        ],
    ConfigBinary     = Json.FromValue(Config),
    ConfigText       = Text.FromBinary(ConfigBinary,TextEncoding.Utf8),
    Url              = Endpoint & "?config=" & Uri.EscapeDataString(ConfigText),
    /*------------------------------------------------------------
    Browser
    ------------------------------------------------------------*/
    Html = Web.BrowserContents(Url),
        ResultText =
                try
                    Text.BetweenDelimiters(
                        Html,
                        "}]}"">",
                        "</pre>"
                    )
                otherwise
                    error Error.Record(
                        "PQGPU",
                        "Runtime result element was not found.",
                        [
                            response = Html
                        ]
                    ),
    /*------------------------------------------------------------
    JSON
    ------------------------------------------------------------*/
    RuntimeResult =
        try
            Json.Document(
                Text.ToBinary(
                    ResultText,
                    TextEncoding.Utf8
                )
            )
        otherwise
            error Error.Record(
                "PQGPU",
                "Runtime returned invalid JSON.",
                [
                    response = ResultText
                ]
            ),
    /*------------------------------------------------------------
    Runtime error
    ------------------------------------------------------------*/
    CheckedResult =
        if
            Record.HasFields(
                RuntimeResult,
                "ok"
            )
            and RuntimeResult[ok] = false
        then
            error Error.Record(
                "PQGPU",
                RuntimeResult[error][message],
                RuntimeResult[error]
            )
        else
            RuntimeResult,
    /*------------------------------------------------------------
    Rows
    ------------------------------------------------------------*/
    Rows =
        if
            not Record.HasFields(
                CheckedResult,
                "rows"
            )
        then
            error Error.Record(
                "PQGPU",
                "Runtime response does not contain rows.",
                CheckedResult
            )
        else
            CheckedResult[rows],
    Raw   = Table.FromRecords(Rows),
    Typed = Table.TransformColumnTypes(
            Raw,
            {
                {"t", type number},
                {"x", Int64.Type},
                {"y", Int64.Type},
                {"c0", type number},
                {"c1", type number},
                {"c2", type number},
                {"c3", type number}
            }
        ),
    Renamed =
        if OutputColumn = "c0"
        then
            Typed
        else
            Table.RenameColumns(
                Typed,
                {
                    {"c0", OutputColumn}
                }
            ),
    Result =
        Table.SelectColumns(
            Renamed,
            {
                "t",
                "x",
                "y",
                OutputColumn
            }
        )
in
    Result
