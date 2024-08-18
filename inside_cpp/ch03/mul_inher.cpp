#include <iostream>

class Point2d{
public:
    virtual ~Point2d(){}
    //virtual int get_point2d() {
    //    std::cout << "get_point2d" << std::endl;
    //    return 10;
    //}
protected:
    int _x=1.0,_y=2.0;
};

class Point3d: public Point2d{
public:
protected:
    int _z=3.0;
};

class Vertex{
public:
    virtual ~Vertex(){}
    //virtual int get_vertex() {
    //    std::cout << "get_vertex" << std::endl;
    //    return 10;
    //}
protected:
    Vertex* next = nullptr;
};

class Vertex3d: public Point3d,public Vertex{
public:
protected:
    int mumble=4.0;
};

int main(int argc,char* argv[]) {
    Vertex3d vertex3d;
    return 0;
}