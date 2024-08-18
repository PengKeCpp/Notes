#include <iostream>

using namespace std;

class Point3d {
public:
    Point3d(){}
    Point3d(int x, int y, int z):x_(x), y_(z), z_(y) {}
    virtual ~Point3d(){}
public:
    static Point3d origin;
    int x_,y_,z_;
};
Point3d Point3d::origin;

struct Base1{int val1;};
struct Base2{int val2;};
struct Derived: Base1, Base2{};

int main(int argc, char* argv[]) {
    int Base2::*bmp = &Base2::val2;
    
    Point3d point_3d(2,4,6);
    int Point3d::*x = &Point3d::x_;
    printf("x:: %p\n", x);
    printf("&point3d::x: %p, x: %d\n", &point_3d.x_, point_3d.x_);
    printf("&point3d::y: %p, y: %d\n", &point_3d.y_, point_3d.y_);
    printf("&point3d::z: %p, z: %d\n", &point_3d.z_, point_3d.z_);
    printf("origin.z: %p\n", &Point3d::origin.z_);
    printf("origin %p\n", &Point3d::origin);
    printf("================================\n");
    printf("&point3d::x: %p\n", &Point3d::x_);
    printf("&point3d::y: %p\n", &Point3d::y_);
    printf("&point3d::z: %p\n", &Point3d::z_);
    return 0;
}