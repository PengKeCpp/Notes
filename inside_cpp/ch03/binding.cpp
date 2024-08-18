#include <iostream>
#include <typeinfo>

using namespace std;

//对于class函数本体的分析将延迟，直至class声明的右大括号出现才开始
//编译失败，C++ Standard 会把稍早的绑定标示为非法的
typedef int length;

class Point3d{
public:
    void mumber(length val) {
        std::cout << typeid(val).name() << std::endl;
        _val = val;
    }
    length mumber() {return _val;}
public:
    typedef float length;
    length _val;
};

int main(int argc, char* argv[]) {
    Point3d point3d;
    point3d.mumber(5);
    return 0;
}