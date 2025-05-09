shader_type canvas_item;
render_mode blend_mix;

uniform vec2 size = vec2(1280.0, 720.0);
uniform float line_width : hint_range(0, 1) = 0.1;
uniform float line_opacity : hint_range(0, 1) = 0.1;
uniform vec2 offset = vec2(0.0, 0.0);
uniform float grid_size = 16.0;

void fragment() {
	vec2 uv = (offset / size) + UV;
	vec2 r = mod(size * uv, vec2(grid_size));
	vec2 lines = smoothstep(1.0 - line_width, 1, r / vec2(grid_size));
	float alpha = dot(lines, vec2(line_opacity, line_opacity));
	COLOR.a = alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
