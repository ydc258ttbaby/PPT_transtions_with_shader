#pragma once
#include <glad/glad.h>
#include<iostream>
class VertexBuffer
{
private:
	unsigned int m_RendererID = 0;
public:
	VertexBuffer()
	{
		std::cout << "VB Con" << std::endl;
	}
	VertexBuffer(const void* data, unsigned int size)
	{
		std::cout<<"VB Con"<<std::endl;
		glGenBuffers(1, &m_RendererID);
		glBindBuffer(GL_ARRAY_BUFFER, m_RendererID);
		glBufferData(GL_ARRAY_BUFFER, size, data, GL_STATIC_DRAW);
	}
	~VertexBuffer()
	{
		std::cout << "VB DeCon" << std::endl;
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glDeleteBuffers(1, &m_RendererID);
	}
	
	void Bind() const 
	{
		glBindBuffer(GL_ARRAY_BUFFER, m_RendererID);
	}
	void UnBind() const 
	{
		glBindBuffer(GL_ARRAY_BUFFER, 0);
	}
	//void operator=(const VertexBuffer &vb)
	//{
		//return ;
	//}
};
