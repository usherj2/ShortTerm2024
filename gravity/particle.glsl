uniform vec2 pos;
uniform vec3 color;

void mainImage(out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 npos = pos/iResolution.xy;

    
    // vec4 draw = texture(iChannel0,uv);
    fragColor = vec4(color, 1.0); // + draw
}

