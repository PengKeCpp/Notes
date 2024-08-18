#ifndef __DATA_MEMBER_H_
#define __DATA_MEMBER_H_
#include <iostream>

//chunkSize放在data segment中, 通过名字签名在data segment中形成一个独一无二的变量
class Point3d_2 {
public:
    static int chunkSize;
};

class Point3d_1 : public  Point3d_2 {
public:
    static int chunkSize;
    float val;
    int num;
};



int Point3d_2::chunkSize = 45;
int Point3d_1::chunkSize = 35; 


#endif