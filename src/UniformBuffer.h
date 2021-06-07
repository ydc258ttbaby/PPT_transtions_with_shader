#pragma once
#include <glad/glad.h>
#include<iostream>
class UniformBuffer
{
public:
	UniformBuffer(){}
	UniformBuffer(const unsigned int& inSize)
		:m_Size(inSize), m_Stride(0), m_ID(0)
	{
		glGenBuffers(1, &m_ID);

		glBindBuffer(GL_UNIFORM_BUFFER, m_ID);
		glBufferData(GL_UNIFORM_BUFFER, inSize, NULL, GL_STATIC_DRAW);
		glBindBuffer(GL_UNIFORM_BUFFER, 0);
	}
	~UniformBuffer()
	{

	}
	void Bind(unsigned int pos)
	{
		glBindBufferRange(GL_UNIFORM_BUFFER, pos, m_ID, 0, m_Size);
		// or
		// glBindBufferBase(GL_UNIFORM_BUFFER, pos, m_ID); 
	}
	void Push(const unsigned int inDataSize,const float* inData)
	{
		glBindBuffer(GL_UNIFORM_BUFFER, m_ID);
		glBufferSubData(GL_UNIFORM_BUFFER, m_Stride, inDataSize, inData);
		glBindBuffer(GL_UNIFORM_BUFFER, 0);
		m_Stride += inDataSize;
	}
	void ResetStride()
	{
		m_Stride = 0;
	}
	void SetSize(const unsigned int& inSize)
	{
		glBindBuffer(GL_UNIFORM_BUFFER, m_ID);
		glBufferData(GL_UNIFORM_BUFFER, inSize, NULL, GL_STATIC_DRAW);
		glBindBuffer(GL_UNIFORM_BUFFER, 0);
	}
private:
	unsigned int m_ID;
	unsigned int m_Size;
	unsigned int m_Stride;


};