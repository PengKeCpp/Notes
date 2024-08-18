#include <iostream>

struct no_virts {
    int d1=1,d2=2;
};
class has_virts: public no_virts{
public:
    virtual void foo() {
        std::cout << "foo() this is a test" << std::endl;
    }
private:
    int d3=3;
};
int main(int argc, char* argv[]) {
    no_virts n_v;
    has_virts h_v;
    return 0;
}