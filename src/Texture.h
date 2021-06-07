#pragma once
#include <glad/glad.h>
#include <iostream>

#include"stb_image.h"

class Texture
{
private:
    unsigned int m_RenderID;
    std::string m_FilePath;
    unsigned char* m_LocalBuffer = nullptr;
    int m_Width = 0,m_Height = 0, m_Channels = 0;
	unsigned int slot = 0;

    void LoadImage(const char* fileName)
    {
        stbi_set_flip_vertically_on_load(true);
        m_LocalBuffer = stbi_load(fileName, &m_Width, &m_Height, &m_Channels, 0);
        std::cout << "texture nChannels: " << m_Channels << std::endl;
        if (m_LocalBuffer)
        {
            float borderColor[] = { 0.0f, 0.0f, 0.0f, 1.0f };

            switch (m_Channels)
            {
            case 3:
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, m_Width, m_Height, 0, GL_RGB, GL_UNSIGNED_BYTE, m_LocalBuffer);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_BORDER);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_BORDER);
                glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor);
                break;
            case 4:
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, m_Width, m_Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, m_LocalBuffer);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_BORDER);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_BORDER);
                glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor);
                break;
            }
            glGenerateMipmap(GL_TEXTURE_2D);
        }
        else
        {
            std::cout << "Failed to load texture" << std::endl;
        }
    }

public:
    Texture(const char* fileName)
        :m_FilePath(fileName)
    {
        glGenTextures(1, &m_RenderID);
        glBindTexture(GL_TEXTURE_2D, m_RenderID);
        LoadImage(fileName);
        //UnBind();
    }
	~Texture()
	{
		//glDeleteTextures(1,&m_RenderID);
		stbi_image_free(m_LocalBuffer);
	}

	void Bind(unsigned int slot = 0) const
	{
		glActiveTexture(GL_TEXTURE0 + slot);
		glBindTexture(GL_TEXTURE_2D, m_RenderID);
	}
	void UnBind() const
	{
		glBindTexture(GL_TEXTURE_2D, 0);
	}

	inline int GetWidth() const { return m_Width; }
	inline int GetHeight() const { return m_Height;}
};
