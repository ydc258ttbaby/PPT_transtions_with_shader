#pragma once
#include"VertexBuffer.h"
#include"VertexBufferLayout.h"

class VertexArray
{
private:
	unsigned int m_RendererID;
public:
	VertexArray()
	{
		std::cout << "VA Con" << std::endl;
		glGenVertexArrays(1, &m_RendererID);
		glBindVertexArray(m_RendererID);
	}
	~VertexArray()
	{
		std::cout << "VA deCon" << std::endl;
		glDeleteVertexArrays(1, &m_RendererID);
	}

	void AddBuffer(const VertexBuffer& vb, const VertexBufferLayout& layout)
	{
		Bind();
		vb.Bind();
		const auto& elements = layout.GetElements();
		unsigned int offset = 0;
		for (unsigned int i = 0; i < elements.size(); i++)
		{
			const auto& element = elements[i];
			glEnableVertexAttribArray(i);
			glVertexAttribPointer(i,element.count,element.type,element.normalized,layout.GetStride(),(const void*)offset);
			offset += element.count * VertexBufferElement::GetSizeOfType(element.type);
		}
	}
	void Bind() const 
	{
		glBindVertexArray(m_RendererID);
	}
	void UnBind() const
	{
		glBindVertexArray(0);
	}
};