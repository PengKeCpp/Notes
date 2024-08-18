## 1、Member的各种调用方式

### 1.1、Nonstatic Member Functions(非静态成员函数)
member function被内化为nonmember的形式,下面就是转化步骤:
 - 1.改写原型函数以安插一个额外的参数到member function中，用以提供存取管道, 使用class object得以将此函数调用,该额外的参数被称为this指针
 - 2.每一个"对nonstatic data member"的存取操作改为经由this指针来存取
 - 3.将每一个成员函数进行函数修饰，一般member 的名称前面加上class名称,形成独一无二的命名

```cpp
Point3d Point3d::normalize() const {
    register float mag = magnitude();
    Point3d normal;
    normal._x = _x / mag;
    normal._y = _y / mag;
    normal._z = _z / mag;
    return normal;
}

//转化为以下调用NRV优化:
void normalize__7Point3dFv(register const Point3d *const this,Point3d& _result){
    register float mag = this->magnitude();
    _result.Point3d::Point3d(this->_x/mag, this->_y/mag, this->_z/mag);
    return;
}

//名称的特殊处理
class Bar{
public:
    int ival;
    //....
};
class Foo:public Bar{
public:
    int ival;
};
//Foo的内部描述
class Foo{
public:
    int ival__3Bar;
    int ival__3Foo;
};
```

### 1.2、Virtual Member Functions(虚拟成员函数)
如果normalize()是一个virtual member function,那么以下的调用:
```cpp
ptr->normalze();
//内部转化:
(*ptr->vptr[1])(ptr)
```
 - 1、vptr由编译器产生的指针,指向virtual table,vptr被安插在声明有一个或多个virtual function的class object中
 - 2、1是virtual table slot 的索引值,关联到normalize()函数
 - 3、第二个ptr表示this指针

如果magnitude()函数也是一个virtual function，它在normalize之中的调用操作将会被转换如下:
```cpp
register float mag = (*this->vptr[2])(this);
```
由于Point3d::magnitude()是在Point3d::normalize()中被调用的,而后者已经由虚拟机制而决议妥当，所以显式地调用Point3d实例会比较有效率，并因此压制而于虚拟机制而产生的不必要的重复调用操作

### 1.3、Static Member Functions(静态成员函数)
Static member functions的主要特性就是它并没有this指针.以下的次要特性主要是源于其主要特性没有this指针:
 - 1、它不能够直接存取其class中的nonstatic members
 - 2、它不能够被声明为const、volatile或virtual
 - 3、它不需要经由class object才被调用

Static member function由于缺乏this指针.因此差不多等同于nonmemeber function.它提供了一个意想不到的好处:成为一个callback函数


## 2、Virtual Member Functions虚拟成员函数
一个类如果有用virtual function那么就需要额外的执行期信息,首先需要再每一个多态的class object身上增加两个members:
 - 1、一个字符串或一个数字，指向class的类型
 - 2、一个指针，指向某表格，表格中持有程序的virtual functions的执行期地址

为了完成这两个步骤的任务:
 - 1、为了找到表格，每一个class object被安插一个由编译器内部产生的指针，指向该表格
 - 2、为了找到函数地址，每一个virtual function被指派一个表格索引值

这些工作都是由编译器完成.

### 多重继承下的Virtual Functions

```cpp
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
//output:
//Derived::b1_f1
//Base1::b1_f2
//Derived::m()
//Derived::n()
//Base2::b1_f1
//Base2::b1_f2
```
总结:
 - 1、子类Derived中有两个虚函数指针,vptr1、vptr2
 - 2、类Derived有两个虚函数表,因为继承了两个基类
 - 3、子类和第一个基类公用vptr1
 - 4、子类中的虚函数覆盖了父类的同名虚函数, 比如Derived::b1_f1()
