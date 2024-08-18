#include <iostream>
#include <string>

using namespace std;

class Base{
public:
    virtual void print() {
        std::cout << "Base" << std::endl;
    }
};

class Derived: public Base{
public:
    void print() override {
        std::cout << "Derived" << std::endl;
    }
};

int main(int argc,char *argv[]) {
    Derived d;
    Base b;
    b = d;
    b.print();
    Base& v_d = d;
    v_d.print();
    return 0;
}