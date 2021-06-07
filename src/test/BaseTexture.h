#pragma once

#include "Test.h"
#include "Renderer.h"
#include "Texture.h"
#include "Camera.h"
#include "Transform.h"
#include <map>
namespace test
{
	class BaseTexture :public TestBase
	{
	public:
		BaseTexture();
		BaseTexture(const Camera& inCamera, const float& inWidth, const float& inHeight);

		~BaseTexture() override;
		void OnUpdate() override;
		void OnUpdateDynamic(time_t systemTime, float deltaTime, const Camera& inCamera) override;
		void OnUpdateDynamic(float deltaTime, const Camera& inCamera) override;
		void OnRender() override;
		void OnImGuiRender() override;
		void Clear();

	private:
		int m_WindowsWidth = 0;
		int m_WindowsHeight = 0;
		float m_Time = 0.0f;
		time_t m_SystemTime = 0.0f;
		glm::vec3 m_LightColor = glm::vec3(1.0, 1.0, 1.0);
		std::vector<std::string> m_shaderNameList;
		// Shader 与 shader 相关
		std::unique_ptr <Shader> m_baseShader;

		// VAO VBO EBO 与顶点数据相关
		std::unique_ptr <VertexArray> m_quadVAO;
		std::unique_ptr <VertexBuffer> m_quadVBO;
		std::unique_ptr <IndexBuffer> m_quadEBO;
		std::unique_ptr <Renderer> m_Renderer;

		Camera m_Camera;
		float m_ratio;

	};
}