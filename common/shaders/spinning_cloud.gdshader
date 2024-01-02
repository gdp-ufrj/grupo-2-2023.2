shader_type canvas_item;

#define PI 3.1415926535897932384626433832795028

uniform float cloud_radius : hint_range(0, 1) = .1;
uniform float cloud_gum_radius : hint_range(0.01, 0.25) = .05;
uniform float gum_spread : hint_range(0.001, 3) = 1.5;
uniform float rotation_speed : hint_range(0, 5) = 1.;

float sdCircle( vec2 p, float r ) { return length(p) - r; }

vec3 inigoColor (in float d) {
  vec3 col = vec3(1.0) - sign(d)*vec3(0.1,0.4,0.7);
  col *= 1.0 - exp(-3.0*abs(d));
  float c = cos(150.0*d);
  col *= 0.8 + 0.2*c*c*c;
  col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.01,abs(d)) );
  return col;
}

void fragment(){
	vec2 uv = (UV*2.)-1.;

	float gumCount = 2. * PI * cloud_radius / (gum_spread * cloud_gum_radius);
	float radius_correction = (gumCount * cloud_gum_radius - cloud_radius * 2. * PI) / gumCount;

	float d = sdCircle(uv, cloud_radius);
	
	for(float i=0.; i < gumCount; i++)
		d = min(d, 
		sdCircle(
			uv+vec2(
				cos(PI*i/(gumCount*0.5) + TIME * rotation_speed), 
				sin(PI*i/(gumCount*0.5) + TIME * rotation_speed)
			)*cloud_radius,
		cloud_gum_radius - radius_correction));

	vec3 c = vec3(0.);
	c += vec3(step(d, 0.0001));

 COLOR = vec4(c, c.r > 0.01 ? 1. : 0.);
}
