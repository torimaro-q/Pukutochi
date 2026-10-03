let        
    shader = "
precision highp float;
uniform vec2 resolution;
uniform float time;
void main()
{
    vec2 uv = gl_FragCoord.xy / resolution;
    float v =
        0.5 +
        0.5 * sin(
            uv.x * 20.0 +
            uv.y * 10.0 +
            time * 2.0
        );

    gl_FragColor =
        vec4(v, v * 0.4, 1.0 - v, 1.0);
}
",
    T    = 3,
    Dt   = 0.01,
    Raw  = PT_GPU_Test(shader,128,128,T,Dt,"0,0,0,1","c0"),
    Pivoted = Table.Pivot(Table.TransformColumnTypes(Raw, {{"x", type text}}, "ja-JP"), List.Distinct(Table.TransformColumnTypes(Raw, {{"x", type text}}, "ja-JP")[x]), "x", "c0")
in
    Pivoted