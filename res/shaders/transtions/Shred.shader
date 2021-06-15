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
uniform float u_width;
uniform float u_height;
#define PI 3.1415926
vec2 transform(vec2 texCoord, vec2 xyOffset, float zOffset, vec2 scaleCenter, float xTheta, vec2 xThetaCenter, float yTheta, vec2 yThetaCenter, float zTheta, vec2 zThetaCenter)
{
	vec2 res = texCoord;
	float projectPar = 0.8;
	// 绕 x 轴旋转
	res = res - xThetaCenter;
	res.y = res.y / cos(xTheta);
	res.y = res.y / (1.0 - projectPar*res.y * sin(xTheta));
	res.x = res.x / (1.0 - projectPar * res.y * sin(xTheta));
	res = res + xThetaCenter;
	// 绕 y 轴旋转
	res = res - yThetaCenter;
	res.x = res.x / cos(yTheta);
	res.y = res.y / (1.0 - projectPar * res.x * sin(yTheta));
	res.x = res.x / (1.0 - projectPar * res.x * sin(yTheta));
	res = res + yThetaCenter;
	// 绕 z 轴旋转
	res = res - zThetaCenter;
	res = res * vec2(u_width, u_height);
	res = vec2(dot(vec2(cos(zTheta), sin(zTheta)), res), dot(vec2(-sin(zTheta), cos(zTheta)), res));
	res = res / vec2(u_width, u_height);
	res = res + zThetaCenter;
	// z 方向位移
	res = res - scaleCenter;
	res = res * (1.0 + zOffset);
	res = res + scaleCenter;
	// xy 方向位移
	res = res - xyOffset;
	return res;
}
float random(vec2 st) {
	return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}
float random(float inV)
{
	return random(vec2(inV));
}
float generateFrag(vec2 texCoord)
{
	vec2 coord = texCoord;
	float num = 12.0;
	float v = ceil(fract(coord.x * num) * 2.0 - 1.0);
	float floorV = floor(coord.x * num * 2.0);
	coord.x = coord.x + random(floorV) / num * 0.5;
	if (coord.y < random(floor(coord.x * num * 2.0)))
		v = 1.0 - v;
	if (texCoord.x < 0.0 || texCoord.x > 1.0 || texCoord.y < 0.0 || texCoord.y > 1.0)
		v = 0.0;
	return v;
}
void main()
{
	vec2 scaleCenter = vec2(0.5);
	vec2 xThetaCenter = vec2(0.5);
	vec2 yThetaCenter = vec2(0.5);
	vec2 zThetaCenter = vec2(0.5);
	vec4 resColor1 = vec4(0.0);
	vec4 resColor2 = vec4(0.0);
	vec2 res1 = texCoord;
	vec2 res2 = texCoord;

	float zOffset = 0.0;
	vec2 xyOffset = vec2(0.0);
	float xTheta = -PI * 0.05;
	float yTheta = PI * 0.1;
	float zTheta = 0.0;

	float t1 = 0.3;
	float t2 = 0.7;// 保证 t1 + t2 = 1.0，且都在 0-1 之间

	if (u_ratio < t1 || u_ratio >= t2)
	{
		float R1 = (-abs(u_ratio - 0.5)+0.5)/t1;
		xTheta = -PI * 0.05 * R1;
		yTheta = PI * 0.1 * R1;
		{
			zOffset = (0.4 )*R1;
			res1 = transform(texCoord,xyOffset,zOffset,scaleCenter,xTheta,xThetaCenter, yTheta,yThetaCenter,zTheta,zThetaCenter);
			float mask = generateFrag(res1);
			if (u_ratio < 0.5)
				resColor1 = texture(u_ourTexture1, res1) * mask;
			else
				resColor1 = texture(u_ourTexture2, res1) * mask;
		}
		{
			zOffset = (0.6) * R1;
			res2 = transform(texCoord, xyOffset, zOffset, scaleCenter, xTheta, xThetaCenter, yTheta, yThetaCenter, zTheta, zThetaCenter);
			float mask = 1.0 - generateFrag(res2);
			if (u_ratio < 0.5)
				resColor2 = texture(u_ourTexture1, res2) * mask;
			else
				resColor2 = texture(u_ourTexture2, res2) * mask;

		}
		FragColor = mix(resColor2, resColor1, resColor1.a);
	}
	if (u_ratio >= t1 && u_ratio < t2)
	{
		float R2 = 1.0 - abs((u_ratio-t1)/(t2-t1)*2.0 - 1.0);
		{
			zOffset = 0.4 - 1.5 * R2;
			xyOffset = vec2(0.7, 0.2) * R2;
			res1 = transform(texCoord, xyOffset, zOffset, scaleCenter, xTheta, xThetaCenter, yTheta, yThetaCenter, zTheta, zThetaCenter);
			float mask = generateFrag(res1);
			if (u_ratio < 0.5)
				resColor1 = texture(u_ourTexture1, res1) * mask;
			else
				resColor1 = texture(u_ourTexture2, res1) * mask;
		}
		{
			zOffset = 0.6 + 5.0 * R2;
			xyOffset = vec2(-1.5, -0.2) * R2;
			res2 = transform(texCoord, xyOffset, zOffset, scaleCenter, xTheta, xThetaCenter, yTheta, yThetaCenter, zTheta, zThetaCenter);
			float mask = 1.0- generateFrag(res2);
			if (u_ratio < 0.5)
				resColor2 = texture(u_ourTexture1, res2) * mask;
			else
				resColor2 = texture(u_ourTexture2, res2) * mask;
		}
		FragColor = mix(resColor2, resColor1, resColor1.a);
	}
};