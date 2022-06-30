shader_type canvas_item;

uniform float shaderStrength = 13;
uniform vec4 color1 = vec4(0.957, .949, .9531, 1.0);
uniform vec4 color2 = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color3 = vec4(0.0859, 0.1015625, 0.11328125, 1);
uniform vec4 color4 = vec4(0.3984375, 0.02734, 0.03125, 1);
uniform vec4 color5 = vec4(0.640625,.0859375,.10156,1.0);
uniform vec4 color6 = vec4(0.72656,0.09375,0.10546,1.0);
uniform vec4 color7 = vec4(0.8945,0.21875,0.23047,1.0);
uniform vec4 color8 = vec4(0.45703,0.6523,0.64843,1.0);

void fragment() {
	float minDiff = -1.0;
	vec4 minColor = vec4(0.0, 0.0, 0.0, 1.0);

	vec2 uv = SCREEN_UV;

	vec4 temp = textureLod(SCREEN_TEXTURE, uv, 0.0);

	minDiff = 1000.0;
	float currDist = distance(color1, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (color1*vec4(shaderStrength)+temp)/vec4(shaderStrength+1.0);
	}
	currDist = distance(color2, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (color2*vec4(shaderStrength)+temp)/vec4(shaderStrength+1.0);
	}
	currDist = distance(color3, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (color3*vec4(shaderStrength)+temp)/vec4(shaderStrength+1.0);
	}
	currDist = distance(color4, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (temp+color4*vec4(shaderStrength))/vec4(shaderStrength+1.0);
	}
	currDist = distance(color5, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (temp+color5*vec4(shaderStrength))/vec4(shaderStrength+1.0);
	}
	currDist = distance(color6, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (temp+color6*vec4(shaderStrength))/vec4(shaderStrength+1.0);
	}
	currDist = distance(color7, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (temp+color7*vec4(shaderStrength))/vec4(shaderStrength+1.0);
	}
	currDist = distance(color8, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (temp+color8*vec4(shaderStrength))/vec4(shaderStrength+1.0);
	}

	COLOR.rgb = minColor.rgb;
}