#include <iostream>
#include <stdio.h>
#include <cstddef>
#include "data_member.h"

using namespace std;

struct Base1 {
    int val1;
};

struct Base2 {
    int val2;
};

struct Derived : Base1, Base2 {

};

void func1(int Derived::* dmp, Derived *pd) {
    //std::cout << pd->*dmp << endl;
    printf("%d\n", pd->*dmp);
}

void func2(Derived* pd) {
    int Base2::* bmp = &Base2::val2;
    printf("Base2: %p\n", bmp);
    func1(bmp, pd);
}

int main(int argc, char* argv[]) {
    //Point3d_1 p1;
    //p1.num = 30;
    //std::cout << "p1: " << Point3d_1::chunkSize << std::endl;
    //cout << "offset num: " << offsetof(Point3d_1, num) << endl;
    //cout << "offset val: " << offsetof(Point3d_1, val) << endl;
    //printf("num: %p\n", &p1);
    //printf("num: %p\n", (int*)(reinterpret_cast<char*>(&p1) + offsetof(Point3d_1, num)));
    Derived d;
    d.val1 = 2;
    d.val2 = 5;
    func2(&d);
    return 0;
}