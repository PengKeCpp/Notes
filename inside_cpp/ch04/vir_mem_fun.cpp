#include <iostream>

using namespace std;

class Point{
public:
    Point(float x=0.0) {}
    virtual ~Point(){}
    virtual Point& mult(float) { return *this;};
    float x() const{ return _x;}
    virtual float y() const{return 0;}
    virtual float z() const{return 0;}
protected:
    float _x;
};

class Point2d: public Point{
public:
    Point2d(float x=0.0, float y=0.0):Point(x),_y(y){}
    ~Point2d() override{}
    Point2d& mult(float) override{
        return *this;
    }
    float y()const {return _y;}
protected:
    float _y;
};

int main(int argc, char* argv[]) {
    Point point;
    Point2d point2d;
    return 0;
}