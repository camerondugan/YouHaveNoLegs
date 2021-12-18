
shader_type canvas_item;

uniform float shaderStrength = 1;
uniform vec4 color_1 = vec4(0.447, .537, .849, 1.0);
uniform vec4 color_2 = vec4(1, 1, 1, 1.0);
uniform vec4 color_3 = vec4(0.6, 0.666, 0.709, 1.0);
uniform vec4 color_4 = vec4(.1725, 0.1843, 0.2, 1.0);
uniform vec4 color_5 = vec4(.137,.1529,.1647,1);

void fragment() {
	float min_diff = -1.0;
	vec4 min_color = vec4(0.0, 0.0, 0.0, 1.0);

	vec2 uv = SCREEN_UV;

	vec4 temp = textureLod(SCREEN_TEXTURE, uv, 0.0);

	min_diff = 1000.0;
	float curr_dist = distance(color_1, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_1*vec4(shaderStrength)+temp)/vec4(shaderStrength+1.0);
	}
	curr_dist = distance(color_2, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_2*vec4(shaderStrength)+temp)/vec4(shaderStrength+1.0);
	}
	curr_dist = distance(color_3, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_3*vec4(shaderStrength)+temp)/vec4(shaderStrength+1.0);
	}
	curr_dist = distance(color_4, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (temp+color_4*vec4(shaderStrength))/vec4(shaderStrength+1.0);
	}

	COLOR.rgb = min_color.rgb;
}