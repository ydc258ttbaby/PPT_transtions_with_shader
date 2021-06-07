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

vec2 transform(vec2 texcoord,vec2 scaleCenter,vec2 scaleRatio)
{
    vec2 res = texcoord;
    // shader 里面的所有 texcoord 的变换操作均与实际坐标点相反
    res = res  - scaleCenter;// 图片从缩放中心点移动到原点
    res = res / scaleRatio;// 执行缩放
    res = res + scaleCenter;// 图片从原点移动到缩放中心点
    return res;
}
void main()
{
    vec4 resColor = vec4(u_ratio, 0.0, 0.0, 1.0);
    float w = 1.0;
    if (u_ratio <= 0.5)
    {
        float ratioNor =  u_ratio*2.0;
        vec2 scaleRatio = vec2(1.0 + 0.1* ratioNor);
        vec4 texColor1 = texture(u_ourTexture1, transform(texCoord,vec2(0.75,0.5),scaleRatio));
        float alpha = clamp(-1.0 / w * texCoord.x + (1.0 + w) / w * (1.0 - ratioNor), 0.0, 1.0);
        resColor = mix(vec4(1.0), texColor1, alpha);
    }
    else
    {
        float ratioNor = (u_ratio - 0.5) * 2.0;
        vec2 scaleRatio = vec2(1.0 + 0.1 * (1.0-ratioNor));
        vec4 texColor2 = texture(u_ourTexture2, transform(texCoord, vec2(0.25, 0.5), scaleRatio));
        float alpha = 1.0-clamp(-1.0 / w * texCoord.x + (1.0 + w) / w * ratioNor, 0.0, 1.0);
        resColor = mix(texColor2,vec4(1.0), alpha);
    }
    FragColor = resColor;
};