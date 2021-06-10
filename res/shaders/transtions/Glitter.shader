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
// 此变换函数对 蜂窝状 进行缩放和旋转
vec2 transform(vec2 texcoord, float theta,vec2 hexagonNum)
{
    vec2 res = texcoord;
    res = res * vec2(u_width, u_height);
    res = res * hexagonNum;
    res = vec2(dot(vec2(cos(theta), sin(theta)), res), dot(vec2(-sin(theta), cos(theta)), res));
    res = res / vec2(u_width, u_height);
    return res;
}
float and(float a, float b)
{
    if(a > 0.5 && b > 0.5)      return 1.0;
    else                        return 0.0;
}
float or(float a, float b)
{
    if (a > 0.5 || b > 0.5)     return 1.0;
    else                        return 0.0;
}
float not(float a)
{
    return 1.0 -a;
}
float random(vec2 st) {
    //return dot(st,vec2(1.0,1.0));
    st = floor(st*1000.0)/1000.0 + vec2(0.001); // 保留三位小数，防止由于精度不够，出现误差
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}
vec2 transform(vec2 texCoord, float theta, vec2 axisPos,  vec2 hexagonNum)
{
    vec2 res = texCoord - axisPos;

    // 蜂窝边缘的宽度
    float lineWidth = 0.0;

    // 执行旋转和投影
    res.x = res.x / cos(theta);
    res.y = res.y / (1.0 - res.x *  sin(theta));
    res.x = res.x / (1.0 - res.x *  sin(theta));

    // r5 代表一个最小拼接块里中间的六边形
    float k1 = 1.0 / (0.52 - lineWidth); // 此处的 0.52 本应是 0.5 但是有bug
    vec2 coord1 = transform(res, PI / 3.0, hexagonNum);
    vec2 coord2 = transform(res, -PI / 3.0, hexagonNum);
    vec2 coord3 = transform(res, 0.0, hexagonNum);
    float v1 = floor(clamp(abs(coord1.y) * k1, 0.0, 1.0));
    float v2 = floor(clamp(abs(coord2.y) * k1, 0.0, 1.0));
    float v3 = floor(clamp(abs(coord3.y) * k1, 0.0, 1.0));
    float r5 = not(or(or(v1, v2), v3)) ;
    // 六边形之外的区域，坐标设置为-1，取背景色
    if(r5 < 1.0)
        res = vec2(-1.001);

    res = res + axisPos;    // 从 (0,0) 移动到 axisPos
    return res;
}
vec2 generateHoneyComb(vec2 hexagonNum,vec2 texCoord,float lineWidth)
{
    // 确定每个 最小拼接块 的中心
    vec2 center = floor(texCoord * hexagonNum) * (1.0 / hexagonNum) + 0.5 / hexagonNum;
    vec2 coord = texCoord - center;

    // 为了画出一个六边形，分别执行 0度、60度、120度 旋转
    vec2 coord1 = transform(coord, PI / 3.0, hexagonNum);
    vec2 coord2 = transform(coord, -PI / 3.0, hexagonNum);
    vec2 coord3 = transform(coord, 0.0, hexagonNum);


    // 分别求出最小拼接块内的各个组块的表达式，通过布尔运算进行组合
    float v1 = floor(clamp(abs(coord1.y) / (0.5 - lineWidth), 0.0, 1.0));
    float v2 = floor(clamp(abs(coord2.y) / (0.5 - lineWidth), 0.0, 1.0));
    float v3 = floor(clamp(abs(coord3.y) / (0.5 - lineWidth), 0.0, 1.0));
    float v4 = floor(clamp(abs(coord1.y) / (0.5 + lineWidth), 0.0, 1.0));
    float v5 = floor(clamp(abs(coord2.y) / (0.5 + lineWidth), 0.0, 1.0));
    float v6 = floor(clamp(abs(coord3.y) / (0.5 + lineWidth), 0.0, 1.0));
    float v7 = floor(clamp(abs(coord3.y) / lineWidth, 0.0, 1.0));

    float vrt = and(floor(coord3.x) + 1.0, floor(coord3.y) + 1.0);
    float vlt = and(-floor(coord3.x), floor(coord3.y) + 1.0);
    float vrd = and(floor(coord3.x) + 1.0, -floor(coord3.y));
    float vld = and(-floor(coord3.x), -floor(coord3.y));

    // 对每个 最小拼接块 的不同六边形的部分，设置不同的随机参数
    vec2 r1 = and(v7, and(vlt, or(or(v4, v5), v6))) * (center + vec2(0.5 / hexagonNum) * vec2(-1.0, 1.0));
    vec2 r2 = and(v7, and(vrt, or(or(v4, v5), v6))) * (center + vec2(0.5 / hexagonNum) * vec2(1.0, 1.0));
    vec2 r3 = and(v7, and(vld, or(or(v4, v5), v6))) * (center + vec2(0.5 / hexagonNum) * vec2(-1.0, -1.0));
    vec2 r4 = and(v7, and(vrd, or(or(v4, v5), v6))) * (center + vec2(0.5 / hexagonNum) * vec2(1.0, -1.0));
    vec2 r5 = not(or(or(v1, v2), v3)) * (center);

    vec2 v = r1 + r2 + r3 + r4 + r5;
    return v;
}

void main()
{
    // 最小拼接块的数量
    vec2 hexagonNum = vec2(30.0, 30.0);
    vec2 honeyCombPos = generateHoneyComb(hexagonNum, texCoord,0.0);

    vec2 axisPos = honeyCombPos;
    float w = 0.5;
    float rotateTheta = clamp(-1.0/w * texCoord.x + u_ratio*(w+1.0)/w + ceil(u_ratio-0.001) * random(axisPos), 0.0, 1.0) * PI;

    vec2 texCoordAfterTransform = transform(texCoord, rotateTheta, axisPos, hexagonNum);
    vec4 texColor1 = texture(u_ourTexture1, texCoordAfterTransform);
    texCoordAfterTransform.x = 2.0*axisPos.x - texCoordAfterTransform.x;
    vec4 texColor2 = texture(u_ourTexture2, texCoordAfterTransform);

    vec4 resColor = vec4(u_ratio, 0.0, 0.0, 1.0);
    if (rotateTheta <= 0.5 * PI)
    {
        float rotateThetaNor = rotateTheta * 2.0 / PI;
        resColor = texColor1 * (1.0 - rotateThetaNor * 0.5);
    }
    else if (rotateTheta > 0.5 * PI)
    {
        float rotateThetaNor = (rotateTheta - 0.5 * PI) * 2.0 / PI;
        resColor = texColor2 * (0.5 + rotateThetaNor * 0.5);
    }
    FragColor = resColor;
};