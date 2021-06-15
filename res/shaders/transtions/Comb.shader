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
void main()
{
	vec4 resColor = vec4(u_ratio, 0.0, 0.0, 1.0);
	float halfCombNum = 3.0;
	float delay = floor(texCoord.y * halfCombNum * 2.0) / halfCombNum * 0.25; // 0-0.5
	float Ry = floor(fract(texCoord.y * halfCombNum) * 2.0);// 0-1-0-1-0-1
	float ratio = clamp(u_ratio * 2.0 - delay * 2.0, 0.0, 1.0);
	if (1.0 - Ry - ratio + (2.0 * Ry - 1.0) * texCoord.x > 0.0)
		resColor = texture(u_ourTexture1, vec2(texCoord.x + (1.0 - 2.0 * Ry) * ratio, texCoord.y));
	else
		resColor = texture(u_ourTexture2, vec2(texCoord.x, texCoord.y));
	FragColor = resColor;
};