## 1、类声明注意点

```cpp
class Abstract_base{
public:
    virtual ~Abstract_base() = 0;
    virtual void interface() const = 0;
    virtual const char* mumble() const {return _mumble;}
protected:
    char *_mumble;
};
```

 - 1、每一个子类的析构函数会被编译器加以扩张, 以静态调用的方式调用其"每一个virtual base class"以及"上一层base class"的destructor,只要缺乏任何一个base class destructor的定义,就会导致链接失败
 - 2、类中函数定义的内容与类型无关时,不应该定义为虚函数
 - 3、对于虚函数一般不定义为const函数, 因为不明确子类是否需要修改其data member

```cpp
//重新考虑class的声明
class Abstract_base{
public:
    virtual ~Abstract_base();
    virtual void interface() = 0;
    const char* mumble() const {return _mumble;}
protected:
    Abstract_base(char* pc = 0);
    char* _mumble;
};
```

## 2、"无继承"情况下的对象构造

### 为继承做准备

```cpp
class Point{
public:
    Point(float x=0.0,float y = 0.0):_x(x),_y(y){}
    virtual float z();
protected:
    float _x,_y;

};
```
每一个class object会多负担一个vptr,对于virtual function的导入会引发编译器对于我们的Point class 产生膨胀的作用:
 - 1、我们所定义的constructor被附加一些代码，以便使vptr初始化。这些代码必须附加在任何base class constructors的调用之后，但必须在任何由使用者提供的代码之前,以下就是可能得附加结果
 - 2、合成的copy constructor和一个copy assignment operator，而且其操作不在是trivial.如果一个Point object 被初始化或一个derived class object 赋值，那么以位为基础的操作可能对vptr带来非法设定


```cpp
Point* Point::Point(Point* this, float x,float y):_x(x),_y(y){
    this->__vptr_Point = __vtbl__Point;
    this->_x = x;
    this->_y = y;
    return *this;
}
```

## 3、继承体系下的对象构造

### 3.1、对象的构造函数

 - 1、记录在member initialization list中的data members 初始化操作会被放进constructor的函数本体中，并以members的声明顺序为顺序
 - 2、如果一个member并没有出现在member initialization list之中，但有一个default constructor，那么default constructor必须被调用
 - 3、如果该类有virtual table pointers,他们必须被设定初值，指向适当的virtual table
 - 4、所有上一层的base class constructor必须被调用，以base class的声明顺序为顺序：
    - 1)、如果base class被列于member initialization list中，那么任何显示指定的参数都应该传递过去
    - 2)、如果base class没有被列于member initialization list中，而default constructor,那么就调用之
    - 3)、如果base class是多重继承下的第二个或后继的base class,那么this指针必须有所调整
 - 5、所有的virtual base class constructors必须被调用，从左至右，从最深到最浅:
    - 1)、如果class被列于member initialization list中, 那么如果有任何显式指定参数，都应该传递过去,若没有列于list之中,而class有一个default constructor,亦应该调用之
    - 2)、class中的每一个virtual base class subobject的偏移位置必须在执行期可被存取
    - 3)、如果class object是最底层的class,其constructors可能被调用:某些用以支持这一行为的机制必须被放进来

### 3.2、虚拟继承

```cpp
class Point3d:public virtual Point{
public:
    Point3d(float x=0.0,float y=0.0,float z=0.0):Point(x,y),_z(z){}
    Point3d(const Point3d& rhs):Point(rhs),_z(rhs._z){}
    ~Point3d(){}
    Point3d& operator=(const Point3d&);
    virtual float z(){return _z;}

protected:
    float _z;
};
//试想下面三种类的派生情况:
class Vertex:virtual public Point{};
class Vertex3d:public Point3d,public Vertex{};
class PVertex:public Vertex3d{};
```
对于Vertex也必须调用Point的constructor. 然而Point3d和Vertex同为Vertex3d的subobjects.他们对Point constructor的调用操作一定不可以发生;但是作为一个最底层的class, Vertex3d有责任将Point初始化.而更往后的继承,则由PVertex来负责初始化"被共享之Point subobject"的构造

以下是Point3d的constructor扩充内容:
```cpp
Point3d* Point3d::Point3d(Point3d* this,bool __most_derived,float x,float y,float z) {
    if(__most_derived != false)
        this->Point::Point(x,y);
    this->__vptr_Point3d = __vtbl_Point3d;
    this->__vptr_Point3d_Point = __vtbl_Point3d_Point;
    this->_z = rhs._z;
    return *this;
}
```

### 3.3、vptr初始化语意学

```cpp
Point(x,y);
Point3d(x,y,z);
Vertex(x,y,z);
Vertex3d(x,y,z);
PVertex(x,y,z);
//假设这个体系结构中的每一个class都定义了一个virtual function size(),此函数负责传回class的大小
```
当每一个PVertex base class constructors被调用时，编译系统必须保证有适当的size()函数实例被调用,将每一个调用操作以静态方式决议之，千万不要用到虚拟机制，如果是在Point3d constructor中，就显示地调用Point3d::size()

constructor的执行算法:
 - 1、在derived class constructor中，所有virtual base classes及上一层base class 的constructors会被调用
 - 2、上述完成之后,对象的vptr被初始化,指向相关的virtual tables
 - 3、如果有member initialization list的话，将在constructor体内扩展开来,这必须在vptr被设定之后才做,以免有一个virtual member function被调用
 - 4、最后执行程序员所提供的代码

例如，已知下面这个由程序员定义的PVertex constructor:

```cpp
PVertex::PVertex(float x,float y,float z):_next(0),Vertex3d(x,y,z),Point(x,y){

    if(spyOn){
        cerr<< "Within PVertex::PVertex()" << "size: " << size() << endl;
    }
}
//它可能会被扩展为:
//C++伪码:

PVertex* PVertex::PVertex(PVertex* this, bool _most_derived, float x,float y,float z){
    //条件式地调用virtual base constructor
    if(_most_derived != false)
        this->Point::Point(x,y);
    //无条件地调用上一层base
    this->Vertex3d::Vertex3d(x,y,z);
    //将相关的vptr初始化
    this->_vptr_PVertex = __vtbl_PVertex;
    this->__vptr_Point3d_Point = __vtbl_Point3d_Point;
    if(spyOn){
        cerr<< "Within PVertex::PVertex()" << "size: " << (*this->_vptr_PVertex[3].faddr)(this)
        << endl;
    }
    return *this;
}
```

何时需要供应参数给一个base class constructor?这种情况下在"class 的constructor"的member initialization list中调用该class的虚拟函数，仍然安全吗?不，此时vptr若不是尚未被设定好，就是设定指向错误的class,更进一步地说，该函数所存取的任何class's data members一定还没有被初始化好

