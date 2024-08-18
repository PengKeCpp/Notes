#include <iostream>

using namespace std;

class Base1{
public:
    virtual void b1_f1(){
        cout << "Base1::b1_f1" << endl;
    }
    virtual void b1_f2() {
        cout << "Base1::b1_f2" << endl;
    }
};

class Base2{
public:
    virtual void b2_f1(){
        cout << "Base2::b1_f1" << endl;
    }
    virtual void b2_f2() {
        cout << "Base2::b1_f2" << endl;
    }
};

class Derived:public Base1,public Base2{
public:
    void b1_f1(){
        cout << "Derived::b1_f1" << endl;
    }

    virtual void m() {
        cout << "Derived::m()" << endl;
    }

    virtual void n() {
        cout << "Derived::n()" << endl;
    }
};

int main(int argc,char* argv[]){

    Derived ins;
    Base1 &b1 = ins;
    Base2 &b2 = ins;
    Derived& d = ins;
    
    using Func = void(*)(void);
    void** pderived1  = (void**)(&ins);
    void** vptr1 = (void**)(*pderived1);
    void** pderived2  = pderived1 + 1;
    void** vptr2 = (void**)(*pderived2);
    Func f1 = (Func)vptr1[0];
    Func f2 = (Func)vptr1[1];
    Func f3 = (Func)vptr1[2];
    Func f4 = (Func)vptr1[3];
    //Func f5 = (Func)vptr1[4];
    f1();
    f2();
    f3();
    f4();
    //f5();
    Func ff1 = (Func)vptr2[0];
    Func ff2 = (Func)vptr2[1];
    ff1();
    ff2();

    return 0;
}