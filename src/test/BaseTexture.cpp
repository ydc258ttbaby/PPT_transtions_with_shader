#include"BaseTexture.h"
#include"imgui/imgui.h"
#include"math.h"
namespace test
{
    BaseTexture::BaseTexture(const Camera& inCamera, const float& inWidth, const float& inHeight)
    {
        m_WindowsWidth = inWidth;
        m_WindowsHeight = inHeight;
        m_Camera = inCamera;
        m_shaderNameList = {
            "Base.shader",
            "Fade.shader",
            "Push.shader",
            "Wipe.shader",
            "Split.shader" ,
            "Reveal.shader",
            "Cut.shader" ,
            "RandomBars.shader",
            "Shape.shader",
            "Uncover.shader",
            "Cover.shader",
            "Flash.shader",
            "Dissolve.shader",
            "Flip.shader",
            "CheckBoard.shader",
            "Blinds.shader",
            "Clock.shader",
            "Ripple.shader",
            "HoneyComb.shader",
            "Glitter.shader",
			"Comb.shader",
			"PageTurn.shader",
            "Zoom.shader",
            "Fall.shader",
            "Cube.shader",
            "DoorAndWindow.shader",
            "Shred.shader",
            "Test.shader",
            "PageCurl.shader",
            "Curtain.shader",
            "Prestige.shader",
            "PeelOff.shader"
        };
        m_baseShader = std::make_unique<Shader>("res/shaders/transtions/"+ m_shaderNameList.back());
        m_quadVAO = std::make_unique<VertexArray>();
        m_Renderer = std::make_unique<Renderer>();
        OnUpdate();
    }
    BaseTexture::~BaseTexture()
    {
    }
    void BaseTexture::OnUpdate()

    {
        float quadVertices[] = {
            // positions              // texture coords
             1.0f,  1.0f, 0.0f,      1.0f, 1.0f, // top right
             1.0f, -1.0f, 0.0f,      1.0f, 0.0f, // bottom right
            -1.0f, -1.0f, 0.0f,      0.0f, 0.0f, // bottom left
            -1.0f,  1.0f, 0.0f,      0.0f, 1.0f  // top left 
        };
        unsigned int quadIndices[] = {
            0, 1, 3, // first triangle
            1, 2, 3  // second triangle
        };

        {
            Texture m_Texture1 = Texture("res/image/Picture3.jpg");
            Texture m_Texture2 = Texture("res/image/Picture4.jpg");
            m_Texture1.Bind(0);
            m_Texture2.Bind(1);
        }
        {
            VertexBufferLayout layout;
            layout.Push<float>(3);
            layout.Push<float>(2);

            m_quadVBO = std::make_unique<VertexBuffer>(quadVertices, sizeof(quadVertices));
            m_quadEBO = std::make_unique<IndexBuffer>(quadIndices, 6);
            m_quadVAO->AddBuffer(*m_quadVBO, layout);
        }
    }
    void BaseTexture::OnUpdateDynamic(float deltaTime, const Camera& inCamera)
    {

    }

    void BaseTexture::OnUpdateDynamic(time_t systemTime,float deltaTime, const Camera& inCamera)
    {
        m_SystemTime = systemTime;
        m_Time += deltaTime;


    }

    void BaseTexture::OnRender()
    {

        m_quadVAO->Bind();
        m_baseShader->Bind();
        m_baseShader->setInt("u_ourTexture1", 0);
        m_baseShader->setInt("u_ourTexture2", 1);
        m_baseShader->setFloat("u_width", m_WindowsWidth);
        m_baseShader->setFloat("u_height", m_WindowsHeight);
        m_baseShader->setFloat("u_ratio", m_ratio);

        m_Renderer->Draw(*m_quadVAO, *m_quadEBO, *m_baseShader);
    }

    void BaseTexture::OnImGuiRender()
    {
        ImGui::SliderFloat("float", &m_ratio, 0.0f, 1.0f);
        std::string s = "Base.shader";
        for (auto& s : m_shaderNameList)
        {
            if (ImGui::Button(s.substr(0,size(s)-7).c_str()))
            {
                m_baseShader = std::make_unique<Shader>("res/shaders/transtions/" + s);
                std::cout << "button clicked!" << std::endl;
            }
        }
    }
    void BaseTexture::Clear()
    {

        glClearColor(0.f, 0.f, 0.f, 1.0f);//设置清理的颜色，即背景颜色
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);//此处有三个选择GL_COLOR_BUFFER_BIT，GL_DEPTH_BUFFER_BIT，GL_STENCIL_BUFFER_BIT

        glEnable(GL_DEPTH_TEST);
        glDepthFunc(GL_LESS);
    }

}