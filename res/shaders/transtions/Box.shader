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
	// xy 位移
	res = res - xyOffset;
	// z 位移，体现为缩放
	res = res - scaleCenter;
	res = res * (1.0 + zOffset);
	res = res + scaleCenter;
	// 旋转
	res = res - thetaCenter;
	res.x = res.x / (cos(theta) + 0.0001);
	res.y = res.y / (1.0 - res.x * sin(theta));
	res.x = res.x / (1.0 - res.x * sin(theta));
	res = res + thetaCenter;
	return res;
}
void main()
{
	vec2 screenCenter = vec2(0.5);
	vec2 thetaCenter = vec2(0.5, 0.5);

	float zOffset1 = (-abs(u_ratio - 1.0 / 3.0) + 1.0 / 3.0) * 0.5;
	vec2 xyOffset1 = vec2(-0.5 * u_ratio, 0.0);
	float theta1 = u_ratio * PI * 0.5;
	vec2 coord1 = transform(texCoord, xyOffset1, zOffset1, screenCenter, theta1, thetaCenter);
	vec4 texColor1 = texture(u_ourTexture1, coord1);

	float zOffset2 = (-abs((1.0 - u_ratio) - 1.0 / 3.0) + 1.0 / 3.0) * 0.5;
	vec2 xyOffset2 = vec2(0.5 * (1.0 - u_ratio), 0.0);
	float theta2 = -(1.0 - u_ratio) * PI * 0.5;
	vec2 coord2 = transform(texCoord, xyOffset2, zOffset2, screenCenter, theta2, thetaCenter);
	vec4 texColor2 = texture(u_ourTexture2, coord2);

	FragColor = texColor1 + texColor2;
};