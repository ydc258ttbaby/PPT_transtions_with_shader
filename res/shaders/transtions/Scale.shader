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
vec2 transform(vec2 texCoord, float zOffset)
{
    vec2 coord = texCoord - vec2(0.5);
    coord = coord * (1 + zOffset); // zOffset 此处指z方向的偏移，实际上指代指缩放因子
    coord = coord + vec2(0.5);
    return coord;

}
void main()
{
    float zOffset1 = -0.5 * u_ratio;// zOffset从 0 -> -0.5，类似缩放因子从 1 -> 1.5
    vec2 coord1 = transform(texCoord, zOffset1);
    vec4 texColor1 = texture(u_ourTexture1, coord1);

    float zOffset2 =  0.5 * (1.0 - u_ratio);// zOffset从 0.5 -> 0，类似缩放因子从 0.5 -> 1
    vec2 coord2 = transform(texCoord, zOffset2);
    vec4 texColor2 = texture(u_ourTexture2, coord2);

    FragColor = mix(texColor1, texColor2, u_ratio);
};