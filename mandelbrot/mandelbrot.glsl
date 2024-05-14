






void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 center = iResolution.xy;
    //Normalized pixel coordinates (from 0 to 1)
    //vec2 uv = fragCoord/iResolution.xy;
    
    //Get the size that each pixel represents
    vec2 p = 1.0 / iResolution.xy;

    // Center our coordinate system    
    vec2 uv = (fragCoord - .5*iResolution.xy) / min(iResolution.x, iResolution.y);
    
    // Show space coordinates as colors on the background
    vec3 col = vec3(uv.x,uv.y,0.0);

    // Output to screen
    fragColor = vec4(col,1.0);
}
