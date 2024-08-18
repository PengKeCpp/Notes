#include <iostream>
#include <memory>

using namespace std;

class Base {
public:
    virtual ~Base() = 0;
    virtual void func() = 0;
    Base() {
        func();
    }
};

Base::~Base() {
    std::cout << "Base" << std::endl;
    func();
}

void Base::func() {
    cout << "Base::func" << endl;
}

class Derived : public Base {
public:
    Derived() {
        func();
    }
    void func() {
        std::cout << "Derived::func" << std::endl;
    }

    ~Derived() override{
        std::cout << "~Derived" << std::endl;
        func();
    }
};

int main(int argc, char* argv[]) {
    Base* pb = new Derived();

    shared_ptr<Base> sp(pb);

    //pb->func();
    //pb->Base::func();
    //Derived d;
    return 0;
}