#shader vertex

#version 330 core

layout(location = 0) in vec3 aPos;
layout(location = 1) in vec2 aTexCoord;
out vec2 texCoord;
void main()
{
	texCoord = aTexCoord;
	gl_Position = vec4(aPos, 1.0);
};

#shader fragment

#version 330 core

out vec4 FragColor;
in vec2 texCoord;
uniform sampler2D u_ourTexture1;
uniform sampler2D u_ourTexture2;
uniform float u_ratio;
#define PI 3.1415926
vec2 transform(vec2 texCoord, vec2 xyOffset, float zOffset, vec2 scaleCenter, float theta, vec2 thetaCenter)
{
	vec2 res = texCoord;
	res = res - scaleCenter;
	res = res * (1.0 + zOffset);
	res = res + scaleCenter;

	res = res - thetaCenter;
	res.x = res.x / cos(theta);
	res.y = res.y / (1.0 - res.x * sin(theta));
	res.x = res.x / (1.0 - res.x * sin(theta));
	res = res + thetaCenter;

	res = res - xyOffset;
	return res;
}
void main()
{
	float zOffset1 = -1.0 * u_ratio;
	vec2 screenCenter = vec2(0.5);

	vec4 texColor1 = vec4(1.0, 0.0, 0.0, 1.0);
	if (texCoord.x < 0.5)
	{
		float theta = u_ratio * PI * 0.5;
		vec2 thetaCenter = vec2(0.0, 0.5);
		vec2 coord1 = transform(texCoord, vec2(0.0, 0.0), zOffset1, screenCenter, theta, thetaCenter);
		if (coord1.x > 0.5)
			coord1.x = 1.001;
		texColor1 = texture(u_ourTexture1, coord1);
	}
	else
	{
		float theta = -u_ratio * PI * 0.5;
		vec2 thetaCenter = vec2(1.0, 0.5);
		vec2 coord1 = transform(texCoord, vec2(0.0, 0.0), zOffset1, screenCenter, theta, thetaCenter);
		if (coord1.x < 0.5)
			coord1.x = -0.001;
		texColor1 = texture(u_ourTexture1, coord1);
	}

	float zOffset2 = 0.5 * (1.0 - u_ratio);// zOffset从 0.5 -> 0，类似缩放因子从 0.5 -> 1
	vec2 coord2 = transform(texCoord, vec2(0.0, 0.0), zOffset2, vec2(0.5), 0.0, vec2(0.0, 0.0));
	vec4 texColor2 = texture(u_ourTexture2, coord2);
	if (coord2.x < 0.0 || coord2.x > 1.0 || coord2.y < 0.0 || coord2.y > 1.0)
	{
		//texColor2 = vec4(1.0); // window
		texColor2 = vec4(0.0); // door
	}

	FragColor = mix(texColor1, texColor2, u_ratio);
};