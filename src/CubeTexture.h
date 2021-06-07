#pragma once
#include <vector>
#include <string>
#include <glad/glad.h>
#include <iostream>
#include"stb_image.h"
class CubeTexture
{
public:
	CubeTexture(const std::vector<std::string>& faces)
	{
		glGenTextures(1, &texID);
		glBindTexture(GL_TEXTURE_CUBE_MAP, texID);
		LoadCubeMap(faces);
	}
	~CubeTexture()
	{

	}
	void Bind(unsigned int slot = 0)
	{
		glActiveTexture(GL_TEXTURE0 + slot);
		glBindTexture(GL_TEXTURE_CUBE_MAP, texID);
	}
	void LoadCubeMap(std::vector<std::string> faces)
	{	


			stbi_set_flip_vertically_on_load(true);
		for (unsigned int i = 0; i < faces.size(); i++)
		{
			m_LocalBuffer = stbi_load(faces[i].c_str(), &m_Width, &m_Height, &m_Channels, 0);
			if (m_LocalBuffer)
			{
				glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + i,0,GL_RGB,m_Width,m_Height,0,GL_RGB,GL_UNSIGNED_BYTE,m_LocalBuffer);
				stbi_image_free(m_LocalBuffer);
			}
			else
			{
				std::cout<<"Failed to load cube map of: "<< faces[i]<<std::endl;
				stbi_image_free(m_LocalBuffer);
			}
		}
		glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE);

	}
private:
	std::vector<std::string> faces;
	unsigned int texID;
	int m_Width = 0, m_Height = 0, m_Channels = 0;
	unsigned char* m_LocalBuffer = nullptr;
};