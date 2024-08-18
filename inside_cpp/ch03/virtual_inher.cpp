#include <iostream>

using namespace std;

class Point2d{
public:
    virtual ~Point2d(){}
protected:
    int _x=1,_y=2;
};

class Vertex: public virtual Point2d{
public:
    virtual ~Vertex(){}
protected:
    Vertex* next = nullptr;
};

class Point3d: public virtual Point2d{
public:
    virtual ~Point3d(){}
protected:
    int _z=3;
};

class Vertex3d: public Vertex, public Point3d{
public:
protected:
    int mumble=4;
};

int main(int argc, char* argv[]) {
    Vertex3d vertex3d;
    return 0;
}