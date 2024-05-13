#ifdef GL_ES
precision mediump float;
#endif

const float PI = 3.14159265358979;

//from https://www.shadertoy.com/view/MtdSRf
float circle(float radius, vec2 circle_pos, vec2 coord) {
    float circ_blur = 1.0;
    float dist = distance(circle_pos, coord);
    return smoothstep(radius + circ_blur, radius - circ_blur, dist); 
}

void mainImage( out vec4 fragColor, in vec2 fragCoord) {
    vec2 center = iResolution.xy; //actual center for some reason, not 1/2
        
    vec3 color1 = vec3(0., 0., 0.) /255.;
    vec3 color2 = vec3(200., 109., 40.) /255.;
    

    float circles = 0.;
    float rayon = 400.;
    
    float rayon2 = 120.;

    float rayon3 = 50.;
    
    vec2 ptSurCercle = center + vec2(cos(PI * iTime), sin(PI* iTime)) * rayon;
    
    vec2 ptSurCercle2 = ptSurCercle + vec2(cos(PI * iTime /0.5), sin(PI* iTime / 0.5)) * rayon2;

    vec2 circle4 = ptSurCercle2 + vec2(cos(PI * iTime /0.25), sin(PI * iTime / 0.25)) * rayon3;
    
    circles += circle(100, center, fragCoord.xy);          
    circles += circle(40, ptSurCercle, fragCoord.xy);
    circles += circle(20, ptSurCercle2, fragCoord.xy);
    circles += circle(10, circle4, fragCoord.xy);

   


    fragColor = mix(vec4(color1, 1.), vec4(color2, 1.), circles );
}