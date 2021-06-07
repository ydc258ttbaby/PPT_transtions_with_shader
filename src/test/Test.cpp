#include"Test.h"
#include"imgui/imgui.h"
namespace test {

	TestMenu::TestMenu(TestBase* currentTestPointer)
		:m_CurrentTest(currentTestPointer)
	{
		
	}

	TestMenu::~TestMenu()
	{
	}

	void TestMenu::OnUpdate()
	{
	}


	void TestMenu::OnRender()
	{
	}

	void TestMenu::OnImGuiRender()
	{
		for (auto& test : m_Tests)
		{
			if (ImGui::Button(test.first.c_str()))
			{

				auto tempPointer = (test);
				m_CurrentTest =  tempPointer.second;
			
			}
		}
	}
}