shader_type canvas_item;

uniform float shaderStrength = 13;
uniform vec4 color_1 = vec4(0.957, .949, .9531, 1);
uniform vec4 color_2 = vec4(1, 1, 1, 1);
uniform vec4 color_3 = vec4(0.0859, 0.1015625, 0.11328125, 1);
uniform vec4 color_4 = vec4(.3984375, 0.02734, 0.03125, 1);
uniform vec4 color_5 = vec4(.640625,.0859375,.10156,1);
uniform vec4 color_6 = vec4(.72656,0.09375,0.10546,1);
uniform vec4 color_7 = vec4(0.8945,0.21875,0.23047,1);
uniform vec4 color_8 = vec4(0.45703,0.6523,0.64843,1);

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
	curr_dist = distance(color_5, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (temp+color_5*vec4(shaderStrength))/vec4(shaderStrength+1.0);
	}
	curr_dist = distance(color_6, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (temp+color_6*vec4(shaderStrength))/vec4(shaderStrength+1.0);
	}
	curr_dist = distance(color_7, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (temp+color_7*vec4(shaderStrength))/vec4(shaderStrength+1.0);
	}
	curr_dist = distance(color_8, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (temp+color_8*vec4(shaderStrength))/vec4(shaderStrength+1.0);
	}

	COLOR.rgb = min_color.rgb;
}