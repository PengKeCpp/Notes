#include <iostream>
#include <stdio.h>
using namespace std;

class X{};
class Y:public virtual X{};
class Z:public virtual X{};
class A:public Y,public Z{};

class Point3d{
public:
    Point3d(){}
public:
    float x;
};
int main() {
    float Point3d::*p1 = 0;
    float Point3d::*p2 = &Point3d::x;
    if (p1 == p2) {
        cout << "p1 & p2 contain the same value--" << endl;
    }
    int *num = nullptr;
    return 0;
}