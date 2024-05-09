#ifdef GL_ES
precision mediump float;
#endif

const float PI = 3.14159265358979;

float circle(float circ_rad, vec2 circle_pos, vec2 coord) {
    float circ_blur = 1.0;
    float dist = distance(circle_pos, coord);
    return smoothstep(circ_rad + circ_blur, circ_rad - circ_blur, dist); 
}

vec2 orbit(float speed) {
    return vec2(cos(PI * iTime / speed), sin(PI * iTime / speed));
}

struct body {
    float mass; 
    vec2 pos; 
    float radius;
};
void new(inout body self, float mass, vec2 pos, float radius){
    self.mass = mass;
    self.pos = pos;
    self.radius = radius;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord) {
    vec2 center = iResolution.xy;

    vec3 color1 = vec3(1., 1., 1.) /255.;
    vec3 color2 = vec3(255., 255., 255.) /255.;

    float objects = 0.;

    body sun;
    new(sun, 100., center, 50.);

    float earth_dist = 300.;
    float earth_speed = .5;

    float moon_dist = 100.;
    float moon_speed = .2;

    vec2 earth_pos = center + (orbit(earth_speed) * earth_dist);
    vec2 moon_pos = earth_pos + (orbit(moon_speed) * moon_dist);

    objects += circle(sun.radius, sun.pos, fragCoord.xy);
    objects += circle(20., earth_pos, fragCoord.xy);
    objects += circle(10., moon_pos, fragCoord.xy);

    fragColor = mix(vec4(color1, 1.), vec4(color2, 1.), objects );
}

