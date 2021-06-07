#pragma once
#include<functional>
#include<vector>
#include<string>
#include"Camera.h"
#include<iostream>
namespace test
{
	class TestBase
	{
	public:
		TestBase(){ std::cout<<"testbase con";}
		virtual ~TestBase(){}
		virtual void OnUpdate() {}
		virtual void OnRender() {}
		virtual void OnImGuiRender() {}
		virtual void OnUpdateDynamic(float deltaTime, const Camera& inCamera) {}
		virtual void OnUpdateDynamic(time_t systemTime,float deltaTime, const Camera& inCamera){}
		virtual void Clear(){}
	};
	class TestMenu :public TestBase
	{
	public:
		TestMenu(TestBase* currentTestPointer);
		~TestMenu() override;
		void OnUpdate() override;
		void OnRender() override;
		void OnImGuiRender() override;
		template<typename T>
		void RegisterTest(const std::string& name)
		{
			std::cout<<"Register Test: "<<name<<std::endl;
			TestBase * tempPointer = new T();
			m_Tests.push_back(std::make_pair(name, tempPointer));
		}
	private:
		TestBase* m_CurrentTest;
		std::vector<std::pair<std::string,TestBase*>> m_Tests;
	};
}