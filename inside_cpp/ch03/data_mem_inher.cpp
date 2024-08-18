#include <iostream>
#include <stdio.h>

using namespace std;

class Concrete1 {
public:
    int val;
    char bit1;
};

class Concrete2: public Concrete1{
public:
    char bit2;
};

class Concrete3: public Concrete2{
public:
    char bit3;
};

void copy_func(Concrete1 *pc1_1,Concrete1 *pc1_2) {
    *pc1_2 = *pc1_1;
}
void copy_func(Concrete2 *pc1_1,Concrete2 *pc1_2) {
    *pc1_2 = *pc1_1;
}

int main(int argc, char* argv[]) {
    std::cout << sizeof(Concrete1) <<std::endl;
    std::cout << sizeof(Concrete2) <<std::endl;
    std::cout << sizeof(Concrete3) <<std::endl;
    Concrete1 pc1;
    pc1.val = 2;
    pc1.bit1 = 69;
    Concrete2 pc2;
    pc2.bit2 = 66;
    printf("bit2: %c\n", pc2.bit2);
    Concrete3 pc3;
    pc3.bit3 = 70;
    copy_func(&pc1, &pc2);
    copy_func(&pc2, &pc3);
    printf("bit2: %c\n", pc2.bit2);
    printf("bit3: %c\n", pc3.bit3);
    return 0;
}