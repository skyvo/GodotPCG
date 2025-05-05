shader_type canvas_item;

// Noise and decal tileset shader by Big Boy Games (Jesse)

uniform sampler2D noise : repeat_enable, filter_nearest;
uniform sampler2D decal : repeat_enable, filter_nearest;
uniform bool displayDecal = false;
varying vec2 worldUV;

void vertex() {
	worldUV = (MODEL_MATRIX*vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec2 noiseCorrect = vec2(1.0,1.0)/vec2(textureSize(noise, 0));
	vec2 decalCorrect = vec2(1.0,1.0)/vec2(textureSize(decal, 0));

	COLOR.rgb = mix(COLOR.rgb, texture(noise, worldUV*noiseCorrect).rgb, texture(noise, worldUV*noiseCorrect).a);

	if (displayDecal) {
		COLOR.rgb = mix(COLOR.rgb, texture(decal, worldUV*decalCorrect).rgb, texture(decal, worldUV*decalCorrect).a * texture(noise, worldUV*noiseCorrect).a);
	}
}
//	// Uncomment to replace the default light processing function with this one.
//}
