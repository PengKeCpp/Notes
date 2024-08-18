#include <iostream>

class Bar{
public:
    static int ival;
};

int Bar::ival = 6;


class Foo: public Bar {
public:
    void xxxx() {
        int y;
    }
    float xxxx(int x) {
        std::cout << Bar::ival << std::endl;
        return 0.1;
    }
    float xxxx(int& x) {
        std::cout << x << std::endl;
        return 0.3;
    }
    float yyyy(Bar& x) {
        std::cout << "test" << std::endl;
        return 0.3;
    }
public:
    static int ival;
};

int Foo::ival = 7;

int main(int argc,char* argv[]) {
    Foo foo;
    //Bar bar;
    foo.yyyy(Bar());
    return 0;
}