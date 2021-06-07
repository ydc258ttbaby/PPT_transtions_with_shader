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
// 此变换函数对纹理坐标产生偏移，以模拟折射效果
vec2 transform(vec2 texCoord, vec2 waveCenter, float radiusOffset)
{
    vec2 res = texCoord;
    res = res - waveCenter;
    float radius = sqrt(pow(res.x, 2.0) + pow(res.y / u_width * u_height, 2.0));
    res = res + radiusOffset * vec2(res.x, res.y / u_width * u_height) / radius;
    res = res + waveCenter;
    return res;
}

void main()
{
    // 水波纹的周期
    float T = PI / 30.0;
    // 水波纹的波的个数
    float waveNum = 3.0;
    // 水波纹中心
    vec2 waveCenter = vec2(0.5, 0.5);
    float texR = sqrt(pow(texCoord.x - waveCenter.x, 2.0) + pow((texCoord.y - waveCenter.y) / u_width * u_height, 2.0));

    float radiusOffset = 0.0; // 初始化折射的偏移量，没有用真实的折射公式来计算，仅仅是根据水波纹的梯度作了偏移
    float intensityOffset = 0.0; // 初始化亮度的调整量，同样根据水波纹的梯度来修改
    // 限定波的出现范围
    if (texR > u_ratio * (sqrt(2.0) + waveNum * T) - waveNum * T && texR < u_ratio * (sqrt(2.0) + waveNum * T))
    {
        float sinFunction = sin(texR * 2.0 * PI / T - u_ratio * 2.0 * PI / T * ((sqrt(2.0) + waveNum * T)));
        radiusOffset = 0.02 * sinFunction;
        intensityOffset = 0.1 * sinFunction;
    }
    // 设置混合参数，为简单的线性函数，同Shape里面的圆形
    float alpha = clamp((u_ratio * (sqrt(2.0) + waveNum * T) - texR) / (1.0 / 2.0 * T), 0.0, 1.0);

    vec2 texCoordAfterTransform = transform(texCoord, waveCenter, radiusOffset);
    vec4 texColor1 = texture(u_ourTexture1, texCoordAfterTransform);
    vec4 texColor2 = texture(u_ourTexture2, texCoordAfterTransform);

    vec4 resColor = mix(texColor1, texColor2, alpha);
    resColor = resColor * (1.0 + intensityOffset);
    FragColor = resColor;
};