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
vec2 transform(vec2 texCoord, float theta, vec2 axisPos, vec2 gridNum)
{
    vec2 res = texCoord -axisPos;    // 从 axisPos 移动到 (0,0)
    // 执行旋转和投影（投影本质上是剪切）
    res.x = res.x / cos(theta);
    res.y = res.y / (1.0 - res.x * 2.0 * sin(theta));
    res.x = res.x / (1.0 - res.x * 2.0 * sin(theta));
    res = res + axisPos;    // 从 (0,0) 移动到 axisPos
    // 对超出棋盘格范围的坐标进行处理，设置为 -0.001 和 1.001 在 GL_CLAMP_TO_BORDER 模式下取背景色
    float halfGridWidth = 0.5 / gridNum.x;
    float halfGridHeight = 0.5 / gridNum.y;
    if (res.x < axisPos.x - halfGridWidth)        res.x = -0.001;
    if (res.x > axisPos.x + halfGridWidth)        res.x = 1.001;
    if (res.y < axisPos.y - halfGridHeight)        res.y = -0.001;
    if (res.y > axisPos.y + halfGridHeight)        res.y = 1.001;
    return res;
}
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}
void main()
{
    vec4 resColor = vec4(u_ratio, 0.0, 0.0, 1.0);
    vec2 gridNum = vec2(7.0,5.0);
    vec2 axisPos = floor(texCoord * gridNum) * (1.0 / gridNum) + 0.5 / gridNum;
    float rotateTheta = clamp(axisPos.x * 2.0 - 4.0 * u_ratio + 1.0 + 2.0*(random(axisPos)-0.5) * u_ratio, 0.0, 1.0) * PI;

    vec2 texCoordAfterTransform = transform(texCoord, rotateTheta, axisPos, gridNum);
    vec4 texColor1 = texture(u_ourTexture1, texCoordAfterTransform);

    texCoordAfterTransform.x = floor(texCoordAfterTransform.x * gridNum.x + 1.0) / gridNum.x - texCoordAfterTransform.x + floor(texCoordAfterTransform.x * gridNum.x) / gridNum.x;

    vec4 texColor2 = texture(u_ourTexture2, texCoordAfterTransform);
    if (rotateTheta <= 0.5 * PI)
    {
        float rotateThetaNor = rotateTheta  * 2.0 / PI;
        resColor = texColor1 * (1.0  - rotateThetaNor * 0.5) ;
    }
    else if (rotateTheta > 0.5 * PI)
    {
        float rotateThetaNor = (rotateTheta -0.5 * PI) * 2.0 / PI;
        resColor = texColor2 * (0.5 + rotateThetaNor * 0.5);
    }
    FragColor = resColor;
};