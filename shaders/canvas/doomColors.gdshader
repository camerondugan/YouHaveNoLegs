shader_type canvas_item;

uniform float shaderStrength = 13;
uniform vec3 color_1 = vec3(0.957, .949, .9531);
uniform vec3 color_2 = vec3(1, 1, 1);
uniform vec3 color_3 = vec3(0.0859, 0.1015625, 0.11328125);
uniform vec3 color_4 = vec3(0.3984375, 0.02734, 0.03125);
uniform vec3 color_5 = vec3(0.640625,0.0859375,0.10156);
uniform vec3 color_6 = vec3(0.72656,0.09375,0.10546);
uniform vec3 color_7 = vec3(0.8945,0.21875,0.23047);
uniform vec3 color_8 = vec3(0.45703,0.6523,0.64843);

void fragment() {
	float min_diff = -1.0;
	vec3 min_color = vec3(0.0, 0.0, 0.0);

	vec4 temp = textureLod(SCREEN_TEXTURE,SCREEN_UV, 0);

	min_diff = 1000.0;
	float curr_dist = distance(color_1, temp.rgb);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_1*vec3(shaderStrength)+temp.rgb)/vec3(shaderStrength+1.0);
	}
	curr_dist = distance(color_2, temp.rgb);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_2*vec3(shaderStrength)+temp.rgb)/vec3(shaderStrength+1.0);
	}
	curr_dist = distance(color_3, temp.rgb);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_3*vec3(shaderStrength)+temp.rgb)/vec3(shaderStrength+1.0);
	}
	curr_dist = distance(color_4, temp.rgb);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (temp.rgb+color_4*vec3(shaderStrength))/vec3(shaderStrength+1.0);
	}
	curr_dist = distance(color_5, temp.rgb);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (temp.rgb+color_5*vec3(shaderStrength))/vec3(shaderStrength+1.0);
	}
	curr_dist = distance(color_6, temp.rgb);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (temp.rgb+color_6*vec3(shaderStrength))/vec3(shaderStrength+1.0);
	}
	curr_dist = distance(color_7, temp.rgb);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (temp.rgb+color_7*vec3(shaderStrength))/vec3(shaderStrength+1.0);
	}
	curr_dist = distance(color_8, temp.rgb);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (temp.rgb+color_8*vec3(shaderStrength))/vec3(shaderStrength+1.0);
	}

	COLOR.rgb = min_color.rgb;
}