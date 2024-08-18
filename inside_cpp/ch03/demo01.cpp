#include <iostream>

using namespace std;

class X{};
class Y:public virtual X{};
class Z:public virtual X{};
class A:public Y,public Z{};

//空类使得这一class的两个object得以在内存中配置独一无二的地址
//empty virtual base class: 既然有了members，就不需要原本为了empty class而安插的一个char
//
int main(int argc, char* argv[]) {
    cout << sizeof(X) << endl;  //1
    cout << sizeof(Y) << endl;  //4
    cout << sizeof(Z) << endl;  //4
    cout << sizeof(A) << endl;  //8
    X x;
    Y y;
    Z z;
    A a;
    return 0;
}