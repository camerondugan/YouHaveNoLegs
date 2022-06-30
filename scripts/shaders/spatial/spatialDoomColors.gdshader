shader_type spatial;
render_mode unshaded;

uniform float shaderStrength = 13;
uniform vec3 color1 = vec3(0.957, .949, .9531);
uniform vec3 color2 = vec3(1, 1, 1);
uniform vec3 color3 = vec3(0.0859, 0.1015625, 0.11328125);
uniform vec3 color4 = vec3(.3984375, 0.02734, 0.03125);
uniform vec3 color5 = vec3(.640625,.0859375,.10156);
uniform vec3 color6 = vec3(.72656,0.09375,0.10546);
uniform vec3 color7 = vec3(0.8945,0.21875,0.23047);
uniform vec3 color8 = vec3(0.45703,0.6523,0.64843);

void fragment() {
	float minDiff = -1.0;
	vec3 minColor = vec3(0.0, 0.0, 0.0);

	vec3 temp = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;

	minDiff = 1000.0;
	float currDist = distance(color1, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (color1*vec3(shaderStrength)+temp)/vec3(shaderStrength+1.0);
	}
	currDist = distance(color2, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (color2*vec3(shaderStrength)+temp)/vec3(shaderStrength+1.0);
	}
	currDist = distance(color3, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (color3*vec3(shaderStrength)+temp)/vec3(shaderStrength+1.0);
	}
	currDist = distance(color4, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (temp+color4*vec3(shaderStrength))/vec3(shaderStrength+1.0);
	}
	currDist = distance(color5, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (temp+color5*vec3(shaderStrength))/vec3(shaderStrength+1.0);
	}
	currDist = distance(color6, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (temp+color6*vec3(shaderStrength))/vec3(shaderStrength+1.0);
	}
	currDist = distance(color7, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (temp+color7*vec3(shaderStrength))/vec3(shaderStrength+1.0);
	}
	currDist = distance(color8, temp);
	if (currDist < minDiff) {
		minDiff = currDist;
		minColor = (temp+color8*vec3(shaderStrength))/vec3(shaderStrength+1.0);
	}

	ALBEDO = minColor.rgb;
}