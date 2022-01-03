#include<stdio.h>
#include<sys/types.h>
#include<netinet/in.h>
#include<sys/socket.h>
#include<errno.h>
#include<string.h>
#include<arpa/inet.h>
#include<stdlib.h>
#include<assert.h>

#define BACKLOG 5


int main(int argc,char* argv[]){
  if(argc <= 1){
    printf("Usage: %s ip_number",argv[0]);
    return 1;
  }
  //建立套接字
  int sock=socket(AF_INET,SOCK_STREAM,0);
  assert(sock>=0);
  //填写ip和端口
  struct sockaddr_in local;
  local.sin_family=AF_INET;
  local.sin_port=htons(atoi(argv[1]));
  local.sin_addr.s_addr=htonl(INADDR_ANY);
  
  //绑定套接字
  int ret=bind(sock,(struct sockaddr*)&local,sizeof(local));
  if(ret==-1){
    perror("bind error");
    assert(ret==-1);
  }
  
  ret=listen(sock,BACKLOG);
  printf("ret: %d\n",ret);
  assert(ret!=-1);
  struct sockaddr_in client;
  bzero(&client,sizeof(client));
  socklen_t len=sizeof(client);
  int connfd=accept(sock,(struct sockaddr*)&client,&len);
  
  if(connfd<0){
    perror("connection failed");
  }else{
    for(;;){
      char buf[1024];
      ssize_t msglen=recv(connfd,buf,sizeof(buf),0);
      if(msglen == 0){
        printf("client quit!!\n");
        break;
      }
      printf("client# %s",buf);
      buf[msglen]=0;
      send(connfd,buf,strlen(buf),0);
    }
  }
  return 0;
}
