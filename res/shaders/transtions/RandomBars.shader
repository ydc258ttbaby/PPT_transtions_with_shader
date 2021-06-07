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

float random(int seed)
{
    return fract(cos(seed) * 10.0);
}
void main()
{
    vec4 texColor1 = texture(u_ourTexture1, texCoord);
    vec4 texColor2 = texture(u_ourTexture2, texCoord);
    
    float w = 0.05;
    float alpha = 1.0;
    int randomBarNum = 20;
    for (int i = 0; i < randomBarNum; i++)
    {
        float pos = random(i);
        // ------------------------------------------------------------------------------------- | 此处乘 3.0 以保证全部都消融
        alpha = min(alpha, clamp(abs(texCoord.x / w - pos / w) + 1.0 + u_ratio * (-( 1.0 / randomBarNum * 3.0) / w - 1.0), 0.0, 1.0));
    }
    FragColor = mix(texColor1, texColor2, alpha);
};