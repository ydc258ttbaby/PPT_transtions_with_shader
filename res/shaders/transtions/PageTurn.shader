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
vec2 transform(vec2 texCoord, float theta, float zOffset)
{
	vec2 res = texCoord - vec2(0.5,1.3);    // 从 (0.5,0.5) 移动到 (0,0)
	// 执行旋转和投影（投影本质上是剪切）
	res.x = res.x / cos(theta);
	res.y = res.y / (1.0 - res.x * sin(theta));
	//res.x = res.x / (1.0 - res.x * sin(theta));
	res = res * (1.0 + zOffset);    // 执行 z 方向的位移，经过投影后，整体视作缩放
	res = res + vec2(0.5, 1.3);    // 从 (0,0) 移动到 (0.5,0.5)
	return res;
}
void main()
{
	// 图片在z方向上的偏移量
	float zOffset = 0.0;
	vec2 texCoordAfterTransform = transform(texCoord, -u_ratio * PI, zOffset);

	if (u_ratio < 0.5)
	{
		if (texCoord.x < 0.5)
			FragColor = texture(u_ourTexture1, texCoord);
		else
		{
			if (texCoordAfterTransform.x > 1.0 || texCoordAfterTransform.x < 0.0 || texCoordAfterTransform.y < 0.0 || texCoordAfterTransform.y > 1.0)
				FragColor = texture(u_ourTexture2, texCoord);
			else
				FragColor = texture(u_ourTexture1, texCoordAfterTransform);
		}
	}
	else
	{
		if (texCoord.x >= 0.5)
			FragColor = texture(u_ourTexture2, texCoord);
		else
		{
				if (texCoordAfterTransform.x > 1.0 || texCoordAfterTransform.x < 0.0 || texCoordAfterTransform.y < 0.0 || texCoordAfterTransform.y > 1.0)
					FragColor = texture(u_ourTexture1, texCoord);
			else
				FragColor = texture(u_ourTexture2, vec2(1.0 - texCoordAfterTransform.x, texCoordAfterTransform.y));
		}

	}
};