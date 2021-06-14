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
	vec4 texColor1 = vec4(0.0);
	vec4 texColor2 = vec4(0.0);
	float intensityOffset = 0.0;
	vec2 thetaCenter = vec2(1.0, 0.5);
	float t1 = 0.4;
	float t2 = 0.7;
	if(u_ratio < t1)
	{
		float R1 = clamp((u_ratio - 0.0)/(t1 -0.0),0.0,1.0);
		float zOffset1 = 0.0;
		vec2 screenCenter1 = vec2(0.5);
		vec2 xyOffset1 = vec2(0.0, 0.0);
		float theta1 = -R1*PI * 0.06;
		vec2 coord1 = transform(texCoord, xyOffset1, zOffset1, screenCenter1, theta1, thetaCenter);
		if (coord1.y < 0.0)
		{
			// 倒影的实现
			coord1.y = -coord1.y- 0.01;
			intensityOffset = -coord1.y * 5.0 - 0.5;
		}
		texColor1 = texture(u_ourTexture1, coord1)*(1.0 + intensityOffset);
	}
	if(u_ratio >= t1 && u_ratio < t2)
	{
		float R2 = clamp((u_ratio - t1) / (t2 - t1), 0.0, 1.0);
		float zOffset1 = 0.2* R2;
		vec2 xyOffset1 = vec2(-0.8*R2,0.0);
		float theta1 = - PI * 0.06;
		vec2 coord1 = transform(texCoord, xyOffset1, zOffset1, screenCenter, theta1, thetaCenter);
		if (coord1.y < 0.0)
		{
			coord1.y = -coord1.y- 0.01;
			intensityOffset = -coord1.y * 5.0 - 0.5;
		}
		texColor1 = texture(u_ourTexture1, coord1) * (1.0 + intensityOffset);

		float zOffset2 = -0.2 * (1.0-R2);
		vec2 xyOffset2 = vec2(1.0 * (1.0-R2), 0.0);
		float theta2 = -PI * 0.06;
		vec2 coord2 = transform(texCoord, xyOffset2, zOffset2, screenCenter, theta2, thetaCenter);
		if (coord2.y < 0.0)
		{
			coord2.y = -coord2.y- 0.01;
			intensityOffset = -coord2.y * 5.0 - 0.5;
		}
		texColor2 = texture(u_ourTexture2, coord2) * (1.0 + intensityOffset);
	}
	if (u_ratio > t2)
	{
		float R3 = clamp((u_ratio - t2) / (1.0 - t2), 0.0, 1.0);
		float zOffset1 = 0.2 * (1.0 - R3);
		vec2 xyOffset1 = vec2(-0.8 - 0.25*R3, 0.0);
		float theta1 = -PI * 0.06 * (1.0 - R3);
		vec2 coord1 = transform(texCoord, xyOffset1, zOffset1, screenCenter, theta1, thetaCenter);
		if (coord1.y < 0.0)
		{
			coord1.y = -coord1.y- 0.01;
			intensityOffset = -coord1.y * 5.0 - 0.5;
		}
		texColor1 = texture(u_ourTexture1, coord1) * (1.0 + intensityOffset);

		float zOffset2 = 0.0;
		vec2 xyOffset2 = vec2(0.0, 0.0);
		float theta2 = -PI * 0.06 * (1.0 - R3);
		vec2 coord2 = transform(texCoord, xyOffset2, zOffset2, screenCenter, theta2, thetaCenter);
		if (coord2.y < 0.0)
		{
			coord2.y = -coord2.y- 0.01;
			intensityOffset = -coord2.y * 5.0 - 0.5;
		}
		texColor2 = texture(u_ourTexture2, coord2) * (1.0 + intensityOffset);
	}
	FragColor = texColor1 + texColor2;
};