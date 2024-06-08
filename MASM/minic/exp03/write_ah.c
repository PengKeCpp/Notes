#define Buffer ((char*)*(int far*)0x200)

main() {
    Buffer=(char*)malloc(20);       //malloc返回的地址=240--->0:[200]=240
    Buffer[10]=0;                   //ds:[24a]=0
    while(Buffer[10]!=8){
        Buffer[Buffer[10]]='a'+Buffer[10]; // ds:[240]='a' ds:[241]='b'
        Buffer[10]++;               //ds:[240]=0   ds:[241]=1  ds:[242]=2
    }
    free(Buffer);
}