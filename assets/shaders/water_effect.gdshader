shader_type canvas_item;

uniform sampler2D color_ramp;

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123)) * clamp(0.75+((sin(TIME) +0.0) /4.0f), 0.5, 1.0);
}

float worley(vec2 uv, float columns, float rows) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
    //vec2 index_uv = floor(vec2(uv.x + sin(TIME) * columns, uv.y+ sin(TIME) * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
    //vec2 fract_uv = fract(vec2(uv.x + sin(TIME) * columns, uv.y+ sin(TIME) * rows));
	
	float minimum_dist = 1.0;  
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			minimum_dist = min(minimum_dist, dist);
		}
	}
	
	return minimum_dist;
}

void fragment() {
    
	float worley = worley(UV + TIME * 0.08f, 3.0, 5.0);
    vec4 color = texture(color_ramp, vec2(worley));

	//COLOR = vec4(vec3(color), 1.0);
    //COLOR = texture(TEXTURE, UV) + color;
    COLOR = color;
}


void vertex() {
	// Called for every vertex the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
