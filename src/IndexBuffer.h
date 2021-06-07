#pragma once
#include <glad/glad.h>

class IndexBuffer
{
private:
	unsigned int m_RendererID = 0;
	unsigned int m_Count = 0;
public:
	IndexBuffer(){};
	IndexBuffer(const unsigned int* data, unsigned int count):m_Count(count)
	{
		//assert(sizeof(unsigned int) == sizeof(GLuint));
		glGenBuffers(1, &m_RendererID);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_RendererID);
		//std::cout << sizeof(data) << std::endl;

		glBufferData(GL_ELEMENT_ARRAY_BUFFER, count*sizeof(unsigned int), data, GL_STATIC_DRAW);
	}
	~IndexBuffer()
	{
		glDeleteBuffers(1, &m_RendererID);
	}
	
	void Bind() const 
	{
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_RendererID);
	}
	void UnBind() const 
	{
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	}
	inline unsigned int GetCount() const { return m_Count;}
};
