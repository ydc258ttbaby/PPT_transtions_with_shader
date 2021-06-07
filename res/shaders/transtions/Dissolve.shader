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

//float random(int seed)
//{
//    return fract(cos(seed) * 10.0);
//}
//float random(float seed)
//{
//    return fract(cos(seed) * 10.0);
//}
float random(vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898, 78.233))) * 43758.5453123);
}
void main()
{
	vec4 resColor = vec4(u_ratio,0.0,0.0,1.0);
    vec4 texColor1 = texture(u_ourTexture1, texCoord);
    vec4 texColor2 = texture(u_ourTexture2, texCoord);
    vec2 gridNum = vec2(55.0,42.0);
    float randomNum = random(floor(texCoord * gridNum)/ gridNum);
    if (u_ratio <= randomNum)
        resColor = texColor1;
    else
        resColor = texColor2;
    FragColor = resColor;
};