#pragma once
#include"VertexArray.h"
#include"Shader.h"
#include"IndexBuffer.h"

class Renderer
{
private:

public:
	Renderer(){}
	void Draw(const VertexArray& va, const Shader& shader) const
	{
		shader.Bind();
		va.Bind();
		glDrawArrays(GL_TRIANGLES, 0, 36); // 使用 VBO
	}
	void Draw(const VertexArray& va, const Shader& shader,const unsigned int count) const
	{
		shader.Bind();
		va.Bind();
		glDrawArrays(GL_TRIANGLES, 0, count); // 使用 VBO
	}
	void DrawInstance(const VertexArray& va, const Shader& shader, const unsigned int count, const unsigned int num) const
	{
		shader.Bind();
		va.Bind();
		glDrawArraysInstanced(GL_TRIANGLES, 0, count,num); // 使用 VBO
	}
	void Draw(const VertexArray& va, const IndexBuffer& ib, const Shader& shader) const
	{
		shader.Bind();
		va.Bind();
		ib.Bind();
		glDrawElements(GL_TRIANGLES, ib.GetCount(), GL_UNSIGNED_INT, 0); // 使用 EBO
	}
	void Clear()
	{
		glClearColor(0.2f, 0.2f, 0.2f, 1.0f);//设置清理的颜色，即背景颜色
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);//此处有三个选择GL_COLOR_BUFFER_BIT，GL_DEPTH_BUFFER_BIT，GL_STENCIL_BUFFER_BIT

		glEnable(GL_DEPTH_TEST);
		glDepthFunc(GL_LESS);
	}
};