#pragma once

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

class Transform
{
public:
	glm::mat4 trans = glm::mat4(1.0f);
	glm::mat4 model = glm::mat4(1.0f);
	glm::mat4 view = glm::mat4(1.0f);
	glm::mat4 projection = glm::mat4(1.0f);
	glm::mat4 MVP = glm::mat4(1.0f);
	glm::vec3 pos = glm::vec3(0.0,0.0,0.0);
	void Init()
	{
		trans = glm::mat4(1.0f);
		model = glm::mat4(1.0f);
		view = glm::mat4(1.0f);
		projection = glm::mat4(1.0f);
		MVP = glm::mat4(1.0f);
	}
	Transform(const glm::vec3 &scale,const float &rotateDegree,const glm::vec3 &rotateAxis,const glm::vec3 &translate)
	{
		SetTrans(scale,rotateDegree,rotateAxis,translate);
	}
	Transform(const glm::mat4& inTrans)
	{
		trans = inTrans;
	}
	Transform(const glm::mat4& P, const glm::mat4& V, const glm::mat4& M)
	{
		trans = P*V*M;
	}
	Transform()
	{
		Init();
	}
	void SetTrans(const glm::vec3& scale, const float& rotateDegree, const glm::vec3& rotateAxis, const glm::vec3& translate)
	{
		// 越靠下的越先执行，先缩放，再旋转，再平移
		trans = glm::translate(trans, translate);
		trans = glm::rotate(trans, glm::radians(rotateDegree), rotateAxis);
		trans = glm::scale(trans, scale);
		pos = translate;
	}
	void SetModel(const glm::vec3& scale, const float& rotateDegree, const glm::vec3& rotateAxis, const glm::vec3& translate)
	{
		model = glm::translate(model, translate);
		model = glm::rotate(model, glm::radians(rotateDegree), rotateAxis);
		model = glm::scale(model, scale);
		pos = translate;
	}
	void SetModel(const glm::mat4& inModel)
	{
		model = inModel;
	}
	void SetView(const glm::vec3& pos,const glm::vec3& target,const glm::vec3& up)
	{
		view = glm::lookAt(pos, target, up);
	}
	void SetView(const glm::mat4& inView)
	{
		view = inView;
	}
	void SetProjection(const float& fov,const int& screenWidth, const int& screenHeight)
	{
		projection = glm::perspective(glm::radians(fov), (float)screenWidth / (float)screenHeight, 0.1f, 100.0f);
	}
	void UpdateMVP()
	{
		MVP = projection * view * model;
	}
	
};