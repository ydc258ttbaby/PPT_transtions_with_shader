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
uniform float u_width;
uniform float u_height;


#define CIRCLE 0
#define DIAMOND 1
#define PLUS 2


void main()
{
    vec4 texColor1 = texture(u_ourTexture1, texCoord);
    vec4 texColor2 = texture(u_ourTexture2, texCoord);
    float w = 0.2;
    float alpha = 1.0;
    int SHAPE = 1; // ¿ÉÑ¡£ºCIRCLE 0 DIAMOND 1 PLUS 2
    if (SHAPE == CIRCLE)
        alpha = clamp((1.0 / w * sqrt(pow(texCoord.x - 0.5, 2.0) + pow((texCoord.y - 0.5) / u_width * u_height, 2.0))) + 1.0 + u_ratio * (-0.5 * sqrt(2.0) / w - 1.0), 0.0, 1.0);
    if (SHAPE == DIAMOND)
        alpha = clamp( abs(1.0 / w *(abs(texCoord.x - 0.5) + abs(texCoord.y - 0.5))) + 1.0 + u_ratio * (-0.5 * 2.0 / w - 1.0), 0.0, 1.0);
    if (SHAPE == PLUS)
        alpha = min(clamp(abs(texCoord.x / w - 0.5 / w) + 1.0 + u_ratio * (-0.5 / w - 1.0), 0.0, 1.0), clamp(abs(texCoord.y / w - 0.5 / w) + 1.0 + u_ratio * (-0.5 / w - 1.0), 0.0, 1.0));
    FragColor = mix(texColor1, texColor2, alpha);
};