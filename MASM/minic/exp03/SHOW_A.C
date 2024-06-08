main(){
    *(char far*)0xB8000920='a';
    *(char far*)0xb8000921=0x02;
}