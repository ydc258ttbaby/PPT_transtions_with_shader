#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <iostream>

#include"Renderer.h"
#include"Camera.h"
#include"stb_image.h"
#include <glm/gtc/type_ptr.hpp>
#include"test/Test.h"
#include"test/BaseTexture.h"

#include "imgui/imgui.h"
#include "imgui/imgui_impl_glfw.h"
#include "imgui/imgui_impl_opengl3.h"

#include<ctime>

void framebuffer_size_callback(GLFWwindow* window, int width, int height);
void processInput(GLFWwindow* window);
void mouse_callback(GLFWwindow* window, double xpos, double ypos);
void scroll_callback(GLFWwindow* window, double xoffset, double yoffset);
void mouse_button_callback(GLFWwindow* window, int button, int action, int mods);

// 窗口大小
const int windowsWidth = 1280;
const int windowsHeight = 720;
// 初始化鼠标位置
float lastX = windowsWidth/2, lastY = windowsHeight/2;
Camera camera(glm::vec3(0.0f, 0.0f, 1.0f));
bool firstMouse = true; 

// mouse action
bool bMousePressed = false;
bool bMouseReleased = true;

// timing
float deltaTime = 0.0f;	// time between current frame and last frame
float lastFrame = 0.0f;

int main()
{
    // glfw: initialize and configure
    // ------------------------------
    glfwInit();
    // 告诉GLFW我们opengl的版本为330以及core模式
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);


    // glfw window creation
    // --------------------

    //  开启 MSAA
    //glfwWindowHint(GLFW_SAMPLES, 4);
    
    GLFWwindow* window = glfwCreateWindow(windowsWidth, windowsHeight, "LearnOpenGL", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    // 注册窗口尺寸变化时的回调函数
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
    // 注册鼠标移动的回调函数
    glfwSetCursorPosCallback(window, mouse_callback); 
    //glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
    glfwSetMouseButtonCallback(window, mouse_button_callback);
    // 注册鼠标滚轮的回调函数
    glfwSetScrollCallback(window, scroll_callback);

    // glad用于管理现代opengl 的函数指针
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }
    ImGui::CreateContext();

    // imgui init
    const char* glsl_version = "#version 330";
    ImGui_ImplGlfw_InitForOpenGL(window, true);
    ImGui_ImplOpenGL3_Init(glsl_version);

    std::vector<std::pair<std::string,test::TestBase*>> testList;

    testList.push_back(std::make_pair("test of texture map", new test::BaseTexture(camera, windowsWidth, windowsHeight)));

    // 开启 Gamma 校正
    //glEnable(GL_FRAMEBUFFER_SRGB);

    auto testChoose = testList[0].second;
    //testChoose->OnUpdate();
    
    // render loop
    // -----------
    while (!glfwWindowShouldClose(window))
    {
        float currentTime = glfwGetTime();
        deltaTime = currentTime - lastFrame;
        lastFrame = currentTime;
        processInput(window);

        time_t now_time = time(NULL);
        //std::cout<<now_time<<std::endl;

        if (testChoose)
        {
            testChoose->Clear();
            testChoose->OnUpdateDynamic(now_time,deltaTime, camera);
            testChoose->OnRender();

            ImGui_ImplOpenGL3_NewFrame();
            ImGui_ImplGlfw_NewFrame();
            ImGui::NewFrame();
            ImGui::Begin("Test");
            testChoose->OnImGuiRender();
            ImGui::End();
            ImGui::Render();
            ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
        }
        glfwSwapBuffers(window);
        glfwPollEvents();
    }
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();
    glfwTerminate();
    //testOfLight.~TestOfLight();
    //std::cin.get();
    return 0;
}
void mouse_callback(GLFWwindow* window, double xpos, double ypos)
{
    if (firstMouse)
    {
        lastX = xpos;
        lastY = ypos;
        firstMouse = false;
    }
    float xoffset(0.0), yoffset(0.0);
    if (bMousePressed)
    {
        xoffset = xpos - lastX;
        yoffset = lastY - ypos;
    }

    lastX = xpos;
    lastY = ypos;

    camera.ProcessMouseMovement(xoffset, yoffset);
    
}
void scroll_callback(GLFWwindow* window, double xoffset, double yoffset)
{
    camera.ProcessMouseScroll(yoffset);
}
// process all input: query GLFW whether relevant keys are pressed/released this frame and react accordingly
// ---------------------------------------------------------------------------------------------------------
void processInput(GLFWwindow* window)
{
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
    float cameraSpeed = 0.05f; // adjust accordingly
    if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS)
        camera.ProcessKeyboard(FORWARD, deltaTime);
    if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS)
        camera.ProcessKeyboard(BACKWARD, deltaTime);
    if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS)
        camera.ProcessKeyboard(LEFT, deltaTime);
    if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS)
        camera.ProcessKeyboard(RIGHT, deltaTime);
    if (glfwGetKey(window, GLFW_KEY_Q) == GLFW_PRESS)
        camera.ProcessKeyboard(UP, deltaTime);
    if (glfwGetKey(window, GLFW_KEY_E) == GLFW_PRESS)
        camera.ProcessKeyboard(DOWN, deltaTime);
}

// glfw: whenever the window size changed (by OS or user resize) this callback function executes
// ---------------------------------------------------------------------------------------------
void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
    // make sure the viewport matches the new window dimensions; note that width and 
    // height will be significantly larger than specified on retina displays.
    glViewport(0, 0, width, height);// 根据窗口大小，更改视口大小
    std::cout<<"Windows Size Changed!!!"<<std::endl;
}
void mouse_button_callback(GLFWwindow* window, int button, int action, int mods)
{
    if (action == GLFW_PRESS) switch (button)
    {
    case GLFW_MOUSE_BUTTON_LEFT:
        
        std::cout<<"Mouse left button clicked!"<<std::endl;
        break;
    case GLFW_MOUSE_BUTTON_MIDDLE:
        std::cout << "Mouse middle button clicked!" << std::endl;
        break;
    case GLFW_MOUSE_BUTTON_RIGHT:
        bMousePressed = true;
        bMouseReleased = false;
        std::cout << "Mouse right button clicked!" << std::endl;
        break;
    }
    if (action == GLFW_RELEASE) switch (button)
    {
    case GLFW_MOUSE_BUTTON_LEFT:
        
        std::cout << "Mouse left button released!" << std::endl;
        break;
    case GLFW_MOUSE_BUTTON_MIDDLE:
        std::cout << "Mouse middle button released!" << std::endl;
        break;
    case GLFW_MOUSE_BUTTON_RIGHT:
        bMouseReleased = true;
        bMousePressed = false;
        std::cout << "Mouse right button released!" << std::endl;
        break;
    }
    return;
}