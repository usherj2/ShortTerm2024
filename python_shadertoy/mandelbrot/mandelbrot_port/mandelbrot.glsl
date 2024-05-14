
//entirely from https://www.shadertoy.com/view/XcBSzz, as a test to get a working version.

//display region
const float X_MIN = -0.743649; // -0.743649; //-2.
const float X_MAX = -0.743637; // -0.743637; //1.
const float Y_MIN = 0.131822125; // 0.131822125; //-0.84375
const float Y_MAX = 0.131828875; // 0.131828875; //0.84375

const int MAX_ITERATIONS = 1000; //250
const int samples = 12;

//Convert [0, 1] range to a custom range
float convertRange(float value, float min, float max) {
    return min + (max - min) * value;
}

//Get pseudorandom number between 0 and 1
float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

//Complex number opearations
float complexAbs(vec2 c) {
    return sqrt((c.x * c.x) + (c.y * c.y));
}

vec2 complexMultiply(vec2 z1, vec2 z2) {
    return vec2(z1.x * z2.x - z1.y * z2.y, z1.x * z2.y + z1.y * z2.x);
}

//Interpolate between two vec3s
vec3 smoothstepVec3(vec3 a, vec3 b, float t) {
    vec3 result;
    result.x = (smoothstep(0.0f, 1.0f, t) * (b.x - a.x) + a.x);
    result.y = (smoothstep(0.0f, 1.0f, t) * (b.y - a.y) + a.y);
    result.z = (smoothstep(0.0f, 1.0f, t) * (b.z - a.z) + a.z);
    return result;
}

//Gradient for pretty colors! :o
vec3 gradient(float value) {
    if (value < 0.16f) {
        return smoothstepVec3(vec3(0, 7, 100), vec3(32, 107, 203), value / 0.16f);
    } else if (value < 0.42f) {
        return smoothstepVec3(vec3(32, 107, 203), vec3(237, 255, 255), (value - 0.16f) / 0.26f);
    } else if (value < 0.6425f) {
        return smoothstepVec3(vec3(237, 255, 255), vec3(255, 170, 0), (value - 0.42f) / 0.2225f);
    } else if (value < 0.8575f) {
        return smoothstepVec3(vec3(255, 170, 0), vec3(0, 2, 0), (value - 0.6425f) / 0.215f);
    } else {
        return vec3(0, 2, 0);
    }
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    //Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord - .5*iResolution.xy) / min(iResolution.x, iResolution.y);
    
    //Get the size that each pixel represents
    vec2 p = 1.0 / iResolution.xy;
    
    //Define float to calculate the average samples for the current pixel (when multi-sampling)
    float avr_iterations = 0.0;
    
    //Loop over all samples for the current pixel
    for (int s = 0; s < samples; s++) {
        //Add random sample offset (when multi-sampling)
        vec2 o = vec2(0., 0.);
        if (samples != 1) {
            o = (rand(uv.xy) - 0.5) * p;
        }

        //UV coordinates converted to display region
        vec2 c = vec2(convertRange(uv.x + o.x, X_MIN, X_MAX), convertRange(uv.y + o.y, Y_MIN, Y_MAX));
        
        //Mandelbrot algorithm
        vec2 z = vec2(0, 0);
        int iterations = 0;
        while(complexAbs(z) < 2.0 && iterations < MAX_ITERATIONS){
            z = complexMultiply(z, z) + c;
            iterations++;
        }
        
        //Add sample's iterations
        avr_iterations += float(iterations);
    }
    //Divide iterations by amount of samples to get the average
    avr_iterations /= float(samples);
    
    //Map iterations to gradient color
    vec3 col = gradient(avr_iterations / float(MAX_ITERATIONS)) / 255.0;

    //Output to screen
    fragColor = vec4(col, 1.0);
}