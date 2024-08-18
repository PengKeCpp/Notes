## Data语意学

### 1、类大小的影响因素
```cpp
#include <iostream>

using namespace std;

class X{};
class Y:public virtual X{};
class Z:public virtual X{};
class A:public Y,public Z{};

int main() {
    cout << sizeof(X) << endl;  //1
    cout << sizeof(Y) << endl;  //4
    cout << sizeof(Z) << endl;  //4
    cout << sizeof(A) << endl;  //8
    return 0;
}

```

对于类X来说，它有一个隐藏的1byte大小,被编译器安插进去的一个char,使得class的两个object得以在内存中配置独一无二的地址.

影响Y和Z的大小受到三个因素的影响:
- 1、语言本身所造成的额外负担,虚表指针
- 2、编译器对于特殊情况所提供的优化处理, 对empty virtual base class 提供特殊支持
- 3、Alignment的限制


empty virtual base class: 一个empty virtual base class 被视为derived class object最开始的一部分, 节省了1byte(既然有了members，就不需要原本为了empty 而安插一个char了)


### 2、Data Member的绑定

```cpp
#include <iostream>
#include <typeinfo>

using namespace std;

//对于class函数本体的分析将延迟，直至class声明的右大括号出现才开始
//编译失败，C++ Standard 会把稍早的绑定标示为非法的
typedef int length;

class Point3d{
public:
    void mumber(length val) {
        std::cout << typeid(val).name() << std::endl;
        _val = val;
    }
    length mumber() {return _val;}
public:
    typedef float length;
    length _val;
};

int main(int argc, char* argv[]) {
    Point3d point3d;
    point3d.mumber(5);
    return 0;
}
```

### 3、Data Member的布局

C++ Standard要求，在同一个access section中, members的排列顺序只需符合"较晚出现的members在class object中有较高的地址",将members的地址看成是函数压参数.

### 4、Data Member的存取

**Static Data Members**

Static Data Members 被编译器提出与class之外,每一个static data member只有一个实例,存放在程序的data segment之中

**Nonstatic Data Members**
Nonstatic data members直接存放在每一个class object之中,没有办法直接存取他们,每一个nonstatic data member的偏移位置在编译时期即可获知

### 5、"继承"与Data Member

**加上多态**

```cpp
class Point2d{
public:
    Point2d(float x=0.0, float y=0.0):_x(x),_y(y){};
    virtual float z(){return 0.0;}
    virtual void operator+=(const Point2d& rhs){
        _x += rhs.x();
        _y += rhs.y();
    }
protected:
    float _x,_y;
};
```
加上多态Point2d类会带来空间和存取时间上的额外负担:
 - 导入一个和Point2d有关的virtual table
 - 在每一个class object中导入一个vptr
 - 加强constructor使它能够在vptr设定初值, 让它指向class所对应的virtual table
 - 加强destructor,使它能够抹消"指向class之相关virtual table"的vptr,destructor的调用顺序是反向的, 从derived class 到base class


**多重继承**

1、把一个derived class object 指定给base class的指针或reference.这个操作并不需要编译器去调停或修改,它很自然的发生而且提供了最佳执行效率
2、把vptr放在class object的起始处。如果base class没有virtual function而derived class有.那么单一继承的自然多态就会被打破.这种情况下, 把一个derived object 转换为其base类型，就需要编译器的介入. 用以调整地址(vptr插入之故)

看以下例子:

```cpp
class Point2d{
public:
//..拥有virtual 接口,所以Point2d 对象中有vptr
protected:
    float _x,_y;
};

class Point3d:public Point2d{
public:
//..
protected:
    float _z;
};

class Vertex{
public:
//...拥有virtual 接口,Vertex 对象中有vptr
protected:
    Vertex *next;
};

class Vertex3d: public point3d,public Vertex{
public:
//...
protected:
    float mumble;
};
```

多重继承的问题主要发生于derived class objects和其第二个或后继的base class objects之间的转换

对一个多重派生对象，将其地址指定给"最左端base class的指针",情况和单一继承时相同,起始地址相同,至于第二个或后继的base class的地址指定操作，则需要将地址修改.

```cpp
Vertex3d v3d;
Vertex *pv;
Point2d *p2d;
Point3d *p3d;
//那么以下指定操作:
pv = &v3d;
//需要做这样的内部转换
//虚拟C++代码
pv = (Vertex*)((char*)&v3d+sizeof(Point3d));
//下面的指定操作,只需要简单的拷贝其地址就行
Vertex3d *pv3d;
Vertex *pv;
//对于以下的指定操作则需要编译器进行转换,注意pv3d的值为0的情况
pv = pv3d ? (Vertex*)((char*)pv3d + sizeof(Point3d)):0;
```

### 6、指向Data Members的指针
取一个nonstatic data member的地址,将会得到**它在class中的offset**; 取一个"绑定于真正class object身上的data member"的地址,将会得到**该member在内存中的真正地址**

