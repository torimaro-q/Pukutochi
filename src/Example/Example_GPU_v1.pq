let
    init =
        [
            type   = "shader",
            source = 
"
precision highp float;
uniform vec2 resolution;
void main()
{
    vec2 uv = gl_FragCoord.xy / resolution;
    vec2 p = uv - vec2(0.32, 0.5);
    float d = length(p);
    float blob = exp(-d * d * 500.0);
    gl_FragColor = vec4(blob, 0.0, 0.0, 1.0);
}
"
        ],
    
    passes =
        {
            [
                name   = "vortex",
                inputs = [state = "state"],
                output = "state",
                shader = 
"
precision highp float;
uniform sampler2D state;
uniform vec2 resolution;
uniform float time;
void main()
{
    vec2 uv = gl_FragCoord.xy / resolution;
    vec2 p  = uv - vec2(0.5);
    float r = length(p);
    float angle = 0.03 / (r + 0.08);
    float c = cos(angle);
    float s = sin(angle);
    vec2 q  = vec2(c * p.x + s * p.y,-s * p.x + c * p.y);
    q += vec2(0.5);
    vec4 stateValue = texture2D(state, q);
    float fade = 0.995 + 0.005 * smoothstep(0.0,0.5,r);
    stateValue.r *= fade;
    gl_FragColor = stateValue;
}
"
            ]   
        },
        
    result = PT_GPU_v1(128,128,1,0.01,init,passes,null,"value"),
    pivoted = Table.Pivot(Table.TransformColumnTypes(result, {{"x", type text}}, "ja-JP"), List.Distinct(Table.TransformColumnTypes(result, {{"x", type text}}, "ja-JP")[x]), "x", "value")
in
    pivoted
