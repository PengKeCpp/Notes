# 构造函数语意学
## 1、Default Constructor的构造操作

有4中情况的类会由编译器合成出有用的默认构造函数:

- 带有Default Constructor的Member class object
- 带有Default Constructor的Base class
- 带有一个virtual function的Class
- 带有一个Virtual Base Class的Class

**1、带有Default Constructor的Member class object**

如果一个class 没有任何constructor，但它内含一个member object,而后者有 default consturctor，那么这个class的implicit default constructor就是"nontrival",编译器需要为该class合成出一个default constructor，例如:

```cpp
class Foo {
public:
    Foo(){}
    Foo(int){}
};

class Bar {
public:
    Foo foo;
    char* str;
}

void foo_bar(){
    Bar bar;
    if(str){

    }...
}
```
被合成的default constructor看起来可能像这样:

```cpp
inline Bar::Bar(){
    //C++伪码
    //初始化Foo是编译器的事情,但是初始化str则是程序员的事,所以str是未被初始化的,要初始化str则需要程序员自己初始化
    foo.Foo::Foo();
}
```

如果有多个class member objects都需要被初始化操作, 则C++语言要求以"member objects 在class中的声明顺序",来调用各个constructors.如下面例子:

```cpp
class Dopey{
public:
    Dopey();...    
};

class Sneezy{
public:
    Sneezy(int);
    Sneezy();...
};

class Bashful(){
public:
    Bashful();...
};

class Snow_White{
public:
    Dopey dopey;
    Sneezy sneezy;
    Bashful bashful;
    ...
private:
    int mumble;
};

//C++编译器扩张后的default constructor
Snow_White::Snow_White():sneezy(1024)
{
    //插入member class object
    //调用其constructor
    dopey.Dopey::Dopey();
    sneezy.Sneezy::Sneezy();
    bashful.Bashful::Bashful();
    mumble = 2048;
}
```

**2、带有Default Constructor的Base Class**
如果一个没有任何constructors的class派生自一个"带有default constructor"的base class,那么需要被合并出来,调用上一层base classes的default constructor(根据他们的声明顺序)

**3、带有virtual function的class**
需要初始化vptr放置适当的virtual table的地址

**4、带有一个virtual base的class**

```cpp
class X{
public:    
    int i;
};
class A:public virtual X{
public:    
    int j;
};
class B:public virtual X{
public:    
    double d;
};
class C:public A,public B{
public:    
    double k;
};

void foo(const A* pa){
    pa->i=1024;
}

main(){
    foo(new A);
    foo(new C);
    //...
}
//编译器无法固定住foo之中"由pa存取的X::i"的实际偏移位置,pa的真正实际类型可以改变,其中X::i可以延迟至执行期才能决定下来
//可能得编译器转变操作
void foo(const A* pa){
    pa->__vbcx->i = 1024;
}
//__vbcX表示编译器产生的指针,指向virtual base class X

//对于class 所定义的每一个constructor,编译器会安插那些"允许每一个virtual base class"的执行期存取操作的代码
```

## 2、Copy Constructor的构造操作
有三种情况会以一个object的内容作为另外一个class object的初值:

- 显示地以一个object的内容作为另外一个class object的初值
- 当object当做参数交给某个函数时
- 当函数传回class object时

```cpp
//情况一:
class X{...};
X x;
X xx = x;
//情况二:
extern void foo(X x);
void bar(){
    X xx;
    foo(xx);
}
//情况三:
X foo_bar(){
    X xx;
    return xx;
}
//当一个class object以另一个同类实例作为初值,上述constructor会被调用. 这可能会导致一个临时性class object 的产生或导致程序代码的蜕变
```

一个良好的编译器可以为大部分class objects 产生bitwise copies,因为他们有bitwise copy semantics(位逐次拷贝),以下4种情况不展现出"bitwise copy semantics":

- 当class 内含member object 而后者的class声明有一个copy constructor时
- 当class 继承自一个base class而后者存在一个copy constructor时
- 当class 声明了一个或多个virtual functions时
- 当class 派生自一个继承串链, 其中有一个或多个virtual base classes时

对于前面两种情况,编译器必须将member 或base class的"copy constructor" 调用操作安插到被合成的copy constructor中

**重新设定virtual Table的指针**
由于子类和父类的虚函数表不是同一个，则虚函数指针也不是同一个因此当一个基类以其子类的对象内容做初始化操作时,其vptr复制操作必须保证安全


**处理virtual base class subobject**

## 3、程序转化语意学

### 显示的初始化操作
```cpp

#include "X.h"

X x0;

void foo_bar() {
    X x1(x0);
    X x2 = x0;
    X x3 = X(x0);
    //...
}
```

必要的程序转化阶段:
 - 重写每一个定义，其中初始化操作会被剔除
 - class的copy constructor调用操作会被安插进去

以下是可能的双阶段转化之后,foo_bar()可能看起来像这样:
```cpp
void foo_bar() {
    X x1;
    X x2;
    X x3;
    //编译器安插X 的copy construction的调用操作
    x1.X::X(x0);
    x2.X::X(x0);
    x3.X::X(x0);
}
```

### 参数的初始化
当把一个class object当做参数传给一个函数，会调用类的拷贝构造函数:

```cpp
//相当于以下形式的初始化操作:
X xx = arg
void foo(X x0);

//下面这样的调用方式:
X xx;
foo(xx);

//编译器会导入所谓的临时性object, 并调用copy constructor 将它进行初始化,然后将临时性的object传给函数:
X __temp0;
__temp0.X::X(xx);

foo(__temp0);

//缺点会产生临时对象, 应该传入一个引用进入函数
```

### 返回值初始化

```cpp
X bar() {
    X xx;
    return xx;
}
```
存在双阶段的转化:

- 1、加上一个额外参数, 类型是class object的一个reference,这个参数将放置"拷贝构建"得到的返回值
- 2、在return指令之前安插一个copy constructor调用操作,以便将欲传回之object的内容当做上述新增参数的初值

```cpp
//C++伪码
void bar(X& _result) {
    X xx;
    //...处理xx
    xx.X::X();
    _result.X::XX(xx);
}
```

### 编译器层面做优化
直接将result参数取代 name return value,NRV优化。下面是bar()定义:
```cpp

X bar(){
    X xx;
    //...处理xx
    return xx;
}
//编译器把其中的xx以result取代:
void bar(X& result){
    //C++伪码
    result.X::X();
    //...直接处理__result
    return;
}
```

## 4、成员们的初始化队伍

编译器会对initianlization list 一一处理并可能重新排序, 以反映出members的声明顺序。它会安插一些代码到constructor体内, 并置于任何explicit user code之前
