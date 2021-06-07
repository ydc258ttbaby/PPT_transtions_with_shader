#shader vertex

#version 330 core

layout (location = 0) in vec3 aPos;
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
	vec4 resColor = vec4(u_ratio,0.0,0.0,1.0);
    float R = 1.0 - u_ratio;
    if (texCoord.x >= R && texCoord.y >= R)
        resColor = texture(u_ourTexture1, vec2(texCoord.x - R, texCoord.y - R));
    else
        resColor = texture(u_ourTexture2, vec2(texCoord.x, texCoord.y));
    FragColor = resColor;
};