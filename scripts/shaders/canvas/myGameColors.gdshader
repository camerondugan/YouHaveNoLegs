shader_type canvas_item;

uniform float shaderStrength = 0.5;
uniform vec4 color_1 = vec4(.968, .972, .976, 1); //white
uniform vec4 color_2 = vec4(.804, 828, .851, 1);  //light grey
uniform vec4 color_3 = vec4(.285, .313, .340, 1); //dark grey
uniform vec4 color_4 = vec4(.128, .144, .160, 1); //light black
uniform vec4 color_5 = vec4(.972, .254, .266, 1); //red
uniform vec4 color_6 = vec4(.973, .777, .309, 1); //yellow
uniform vec4 color_7 = vec4(.262, .664, .543, 1); //green
uniform vec4 color_8 = vec4(.152, .488, .629, 1); //blue
uniform vec4 color_9 = vec4(0.1,0.1,0.1,1); //Blackish
uniform vec4 color_10 = vec4(0.05,0.05,0.05,1); //almost pure black

void fragment() {
	float min_diff = -1.0;
	vec4 min_color = vec4(0.0, 0.0, 0.0, 1.0);

	vec2 uv = SCREEN_UV;

	vec4 temp = textureLod(SCREEN_TEXTURE, uv, 0.0);

	min_diff = 1000.0;
	float curr_dist = distance(color_1, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_1*vec4(shaderStrength) + (temp*vec4(1.0-shaderStrength)));
	}
	curr_dist = distance(color_2, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_2*vec4(shaderStrength) + (temp*vec4(1.0-shaderStrength)));
	}
	curr_dist = distance(color_3, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_3*vec4(shaderStrength) + (temp*vec4(1.0-shaderStrength)));
	}
	curr_dist = distance(color_4, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_4*vec4(shaderStrength) + (temp*vec4(1.0-shaderStrength)));
	}
	curr_dist = distance(color_5, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_5*vec4(shaderStrength) + (temp*vec4(1.0-shaderStrength)));
	}
	curr_dist = distance(color_6, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_6*vec4(shaderStrength) + (temp*vec4(1.0-shaderStrength)));
	}
	curr_dist = distance(color_7, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_7*vec4(shaderStrength) + (temp*vec4(1.0-shaderStrength)));
	}
	curr_dist = distance(color_8, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_8*vec4(shaderStrength) + (temp*vec4(1.0-shaderStrength)));
	}
	curr_dist = distance(color_9, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_9*vec4(shaderStrength) + (temp*vec4(1.0-shaderStrength)));
	}
	curr_dist = distance(color_10, temp);
	if (curr_dist < min_diff) {
		min_diff = curr_dist;
		min_color = (color_10*vec4(shaderStrength) + (temp*vec4(1.0-shaderStrength)));
	}

	COLOR.rgb = min_color.rgb;
}