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
#define PI 3.1415926

out vec4 FragColor;
in vec2 texCoord;
uniform sampler2D u_ourTexture1;
uniform sampler2D u_ourTexture2;
uniform float u_ratio;

// 用此函数来计算角度，以处理四个象限的不同情况
float atan2(float a, float b)
{
    if (a > 0 && b > 0)
        return atan(b / a);
    if (a < 0 && b > 0)
        return atan(-a / b) + PI / 2.0;
    if (a < 0 && b < 0)
        return atan(b / a) + PI;
    if (a > 0 && b < 0)
        return atan(a / -b) + PI * 3.0 / 2.0;
}
void main()
{
    vec4 texColor1 = texture(u_ourTexture1, texCoord);
    vec4 texColor2 = texture(u_ourTexture2, texCoord);
    float w = 0.2;
    float theta = atan2(texCoord.y-0.5,texCoord.x-0.5);
    // 此处可参考 Wips擦除 效果里面的实现
    float alpha = clamp(1 / w * theta + 1.0 + u_ratio * (-2.0 * PI / w - 1.0), 0.0, 1.0);
    FragColor = mix(texColor2, texColor1, alpha);
};