#define Buffer ((char*)*(int far*)0x200)

f() {
    Buffer = 0;
    Buffer[10]=0;
    while(Buffer[10]!=8) {
        Buffer[Buffer[10]]='a'+Buffer[10];
        Buffer[10]++;
    }
}