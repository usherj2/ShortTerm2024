#ifdef GL_ES
precision mediump float;
#endif

const float PI = 3.14159265358979;

//from https://www.shadertoy.com/view/MtdSRf
float circle(vec2 circle_pos, vec2 coord) {
    float circ_rad = 15.0;
    float circ_blur = 1.0;
    float dist = distance(circle_pos, coord);
    return smoothstep(circ_rad + circ_blur, circ_rad - circ_blur, dist); 
}

void mainImage( out vec4 fragColor, in vec2 fragCoord) {
    vec2 center = iResolution.xy * 0.5;
        
    vec3 color1 = vec3(113., 27., 134.) /255.;
    vec3 color2 = vec3(255., 109., 40.) /255.;
    
    float circles = 0.;
    float rayon = 50.;
    
    float rayon2 = 100.;
    
    vec2 ptSurCercle = center + vec2(cos(PI * iTime), sin(PI* iTime)) * rayon;
    
    vec2 ptSurCercle2 = center + vec2(cos(PI * iTime /0.5), sin(PI* iTime / 0.5)) * rayon2;
    
    circles += circle( center, fragCoord.xy);          
    circles += circle( ptSurCercle, fragCoord.xy);
    circles += circle( ptSurCercle2, fragCoord.xy);
    
    

    fragColor = mix(vec4(color1, 1.), vec4(color2, 1.), circles );
}