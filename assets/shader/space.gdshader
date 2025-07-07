shader_type spatial;
uniform sampler2D tiling_texture;
render_mode unshaded;
uniform float tiling_scale = 4.0;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	vec2 tiling_uv = uv * tiling_scale;
	vec4 texture_result = texture(tiling_texture, tiling_uv);
	ALBEDO = texture_result.rgb;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
