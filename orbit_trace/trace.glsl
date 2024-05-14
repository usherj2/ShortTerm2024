#ifdef GL_ES
precision mediump float;
#endif

const float PI = 3.14159265358979;
const float G = 40.0;

float circle(float circ_rad, vec2 circle_pos, vec2 coord) {
    float circ_blur = 1.0;
    float dist = distance(circle_pos, coord);
    return smoothstep(circ_rad + circ_blur, circ_rad - circ_blur, dist); 
}

vec2 orbit(vec2 center, float speed, float radius) {
    return center + vec2(cos(PI * iTime / speed), sin(PI * iTime / speed)) * radius;
}
//thanks to https://stackoverflow.com/questions/58461958/general-question-are-shading-languages-shaders-object-oriented
// and https://www.shadertoy.com/view/lllGR7
struct body {
    float mass; 
    vec2 pos; 
    vec2 vel;
    float radius;

}; //constructor for type body
void new(inout body self, float mass, vec2 pos, vec2 vel, float radius) {
    self.mass = mass;
    self.pos = pos;
    self.vel = vel;
    self.radius = radius;
}
float gravity(body self, body other) {
    vec2 d = self.pos - other.pos;
    float r = d.x*d.x + d.y*d.y;
    return G * self.mass * other.mass / r;
}
body update(inout body self, body other) {
    vec2 d = other.pos - self.pos;
    vec2 acc = d + gravity(self, other); //adding works better???
    self.vel += acc / self.mass * iTime;
    self.pos += self.vel * iTime;
    return self;
} 

void mainImage( out vec4 fragColor, in vec2 fragCoord) {

    

    vec2 center = iResolution.xy;
    vec3 color1 = vec3(1., 1., 1.) /255.;
    vec3 color2 = vec3(255., 255., 255.) /255.;

    vec2 test_vel = vec2(50., 50.);

    float objects = 0.;

    vec2 zero = vec2(0., 0.);
    
    body sun;
    new(sun, 0., center, zero, 100.);

    body earth;
    new(earth, 0., center, zero, 50.);

    body moon;
    new(moon, 0., center, zero, 25.);

    body rock;
    new(rock, 0., center, zero, 10.);

    earth.pos = orbit(sun.pos, .80, 400.);
    moon.pos = orbit(earth.pos, .70, 200.);
    rock.pos = orbit(moon.pos, .60, 75.);

    vec2 uv = (fragCoord - .5*iResolution.xy) / min(iResolution.x, iResolution.y);
    float px = 1.0 / iResolution.y;
    float d = distance(uv, rock.pos);


    objects += circle(sun.radius, center, fragCoord.xy);
    objects += circle(earth.radius, earth.pos, fragCoord.xy);
    objects += circle(moon.radius, moon.pos, fragCoord.xy);
    objects += circle(rock.radius, rock.pos, fragCoord.xy);
    // doesnt stay put
    objects += circle(1., rock.pos, fragCoord.xy);

    
    fragColor = mix(vec4(color1, 1.), vec4(color2, 1.), objects );
}
