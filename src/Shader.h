#ifndef SHADER_H
#define SHADER_H 
#include <glad/glad.h>

#include <iostream>
#include<fstream>
#include<sstream>
#include<string>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>


class Shader
{
public:
	unsigned int programID = 0;
    Shader()
    {
        std::cout << "Shader Con" << std::endl;

    }
	Shader(const std::string& filepath)
	{
        std::cout << "Shader Con" << std::endl;
        ShaderProgramSource ShaderSource = ParseShader(filepath);
        std::cout << ShaderSource.VertexSource;
        std::cout << ShaderSource.FragmentSource;

        const char* vertexShaderSource = ShaderSource.VertexSource.c_str();
        const char* fragmentShaderSource = ShaderSource.FragmentSource.c_str();

        programID = CreateShader(vertexShaderSource, fragmentShaderSource);
	}
    ~Shader()
    {
        std::cout << "Shader deCon" << std::endl;
        glUseProgram(0);
        glDeleteProgram(programID);
    }
    void Bind() const 
    {
        glUseProgram(programID);
    }
    void UnBind() const
    {
        glUseProgram(0);
    }
    // uniform¹¤¾ßº¯Êý
    void setBool(const std::string& name, bool value) const
    {
        glUniform1i(glGetUniformLocation(programID, name.c_str()), (int)value);
    }
    void setInt(const std::string& name, int value) const
    {
        glUniform1i(glGetUniformLocation(programID, name.c_str()), value);
    }
    void setFloat(const std::string& name, float value) const
    {
        glUniform1f(glGetUniformLocation(programID, name.c_str()), value);
    }
    void setMatrix4fv(const std::string& name, float* value) const
    {
        glUniformMatrix4fv(glGetUniformLocation(programID, name.c_str()), 1, GL_FALSE, value);
    }
    void setVec3f(const std::string& name, float* value) const
    {
        glUniform3fv(glGetUniformLocation(programID, name.c_str()), 1, value);
    }
    void setVec2f(const std::string& name, float* value) const
    {
        glUniform2fv(glGetUniformLocation(programID, name.c_str()), 1, value);
    }
    void setVec3f(const std::string& name, float x,float y,float z) const
    {
        glUniform3fv(glGetUniformLocation(programID, name.c_str()), 1, glm::value_ptr(glm::vec3(x,y,z)));
    }

    void UniformBlockBind(const std::string& name,const unsigned int& pos)
    {
        glUniformBlockBinding(programID, glGetUniformBlockIndex(programID, name.c_str()), pos);
    }
private:
    struct ShaderProgramSource
    {
        std::string VertexSource;
        std::string FragmentSource;
    };
    static ShaderProgramSource ParseShader(const std::string& filepath)
    {
        std::ifstream stream(filepath);
        enum class ShaderType
        {
            NONE = -1, VERTEX = 0, FRAGMENT = 1
        };
        std::string line;
        std::stringstream ss[2];
        ShaderType type = ShaderType::NONE;
        while (getline(stream, line))
        {
            if (line.find("#shader") != std::string::npos)
            {
                if (line.find("vertex") != std::string::npos)
                    type = ShaderType::VERTEX;
                else if (line.find("fragment") != std::string::npos)
                    type = ShaderType::FRAGMENT;
            }
            else
            {
                ss[(int)type] << line << '\n';
            }
        }
        return { ss[0].str(),ss[1].str() };
    }

    static unsigned int CompileShader(unsigned int type, const std::string& source)
    {
        unsigned int id = glCreateShader(type);
        const char* src = source.c_str();
        glShaderSource(id, 1, &src, NULL);
        glCompileShader(id);
        // check for shader compile errors
        int success;
        char infoLog[512];
        glGetShaderiv(id, GL_COMPILE_STATUS, &success);
        if (!success)
        {
            glGetShaderInfoLog(id, 512, NULL, infoLog);
            std::cout << "ERROR::SHADER::VERTEX::COMPILATION_FAILED\n" << infoLog << std::endl;
        }
        return id;
    }

    static unsigned int CreateShader(const std::string& vertexShader, const std::string& fragmentShader)
    {
        unsigned int program = glCreateProgram();
        unsigned int vs = CompileShader(GL_VERTEX_SHADER, vertexShader);
        unsigned int fs = CompileShader(GL_FRAGMENT_SHADER, fragmentShader);
        int success;
        char infoLog[512];
        glAttachShader(program, vs);
        glAttachShader(program, fs);
        glLinkProgram(program);
        // check for linking errors
        glGetProgramiv(program, GL_LINK_STATUS, &success);
        if (!success) {
            glGetProgramInfoLog(program, 512, NULL, infoLog);
            std::cout << "ERROR::SHADER::PROGRAM::LINKING_FAILED\n" << infoLog << std::endl;
        }
        glDeleteShader(vs);
        glDeleteShader(fs);
        return program;
    }
    
};
#endif