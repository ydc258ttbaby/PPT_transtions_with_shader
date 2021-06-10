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
vec2 transform(vec2 texCoord, vec2 xyOffset, float zOffset, vec2 scaleCenter, float theta, vec2 rotateCenter)
{
	vec2 res = texCoord;
	//  这个场景不需要 z 偏移，故可注去
	//res = res - scaleCenter;
	//res = res * (1.0 + zOffset);
	//res = res + scaleCenter;

	// 绕 x 轴旋转结合透视，体现为 x 轴方向的剪切，y轴方向的缩放和剪切，且添加了弯曲因素，使得图片看上去弯曲了
	res = res - rotateCenter;
	res.y = clamp(res.y / cos(theta), -0.5, 1.5);
	float yWrapFact = (0.3 * (1.0 - res.x) * u_ratio);// y 坐标的弯曲，与 x 呈线性变化，体现为左边低一些
	res.y = res.y * (1.0 + res.y * sin(theta) + yWrapFact);
	float xWrapFact = 0.2 * (1.1 - res.x) * u_ratio * sin((res.y + 0.2 * res.x + 0.1) * PI);// x 坐标的弯曲，用 sin 函数进行干扰
	res.x = res.x * (1.0 + (res.y * sin(theta) + xWrapFact));
	res = res + rotateCenter;

	//  这个场景不需要 xy 偏移，故可注去
	// res = res - xyOffset;
	return res;
}
void main()
{
	vec4 resColor = vec4(1.0, 0.0, 0.0, 1.0);
	float zOffset1 = 0.0;
	vec2 screenCenter = vec2(0.5);
	vec2 xyOffset = vec2(0.0);
	vec2 rotateCenter = vec2(0.5, 0.0);

	// theta 是一个分段函数，用于控制坠落速度，先线性后三次函数
	float b = 0.001;
	float a = 0.2;
	float theta = b / a * u_ratio * PI * 0.5;
	if (u_ratio > a)
		theta = (pow((u_ratio - a) / (1.0 - a), 3.0) * (1.0 - b) + b) * PI * 0.5;

	vec2 coord1 = transform(texCoord, xyOffset, zOffset1, screenCenter, theta, rotateCenter);

	//  控制图片变暗的因子
	float fadeRatio = 1.0 - 0.5 * u_ratio;
	resColor = fadeRatio * texture(u_ourTexture1, coord1);
	// 坠落图片意外的区域，显示第二张图
	if (coord1.x < 0.0 || coord1.x > 1.0 || coord1.y < 0.0 || coord1.y > 1.0)
		resColor = texture(u_ourTexture2, texCoord);

	FragColor = resColor;
};