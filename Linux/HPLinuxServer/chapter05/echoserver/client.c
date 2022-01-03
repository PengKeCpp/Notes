#include<stdio.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<stdlib.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<errno.h>
#include<string.h>

int main(int argc,char* argv[]){
  if(argc!=3){
    printf("Usage: %s ip_address port_number\n",argv[0]);
  }
  //创建套接字
  int sock=socket(AF_INET,SOCK_STREAM,0);
  struct sockaddr_in remote;
  remote.sin_family=AF_INET;
  remote.sin_addr.s_addr=inet_addr(argv[1]);
  remote.sin_port=htons(atoi(argv[2]));

  if(connect(sock,(struct sockaddr*)&remote,sizeof(remote))<0){
    perror("connection error");
  }else{
    for(;;){
      char buffer[1024];
      printf("please enter# ");
      scanf("%s",buffer);
      send(sock,buffer,sizeof(buffer),0);
      recv(sock,buffer,sizeof(buffer),0);
      printf("server echo# %s",buffer);
    }
  }
  return 0;
}
