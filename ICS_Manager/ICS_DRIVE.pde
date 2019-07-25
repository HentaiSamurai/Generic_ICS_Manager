int checkPos(int id){
  if(port!=null){
    byte data[]={byte((byte)0x80|(byte)id),0,0};
    clearBuf();
    port.write(data);
    delay(60);
    if(port.available()<6){
      println("timeout ",port.available());
      return -1;
    }
    for(int i=0;i<3;i++){
      if((byte)port.read()!=data[i]){
        println("fail to send");
        return -1;
      }
    }
    if((byte)port.read()!=(byte)id){
      println("fail to send");
      return -1;
    }
    int pos=(port.read()<<7)+port.read();
    //println(pos);
    return(pos);
  }
  return -1;
}
int writePos(int id,int pos){
  if(port!=null){
    clearBuf();
    byte posH=(byte)(0x7F&pos>>7);
    byte posL=(byte)(0x7F&pos);
    //println(hex(posH),hex(posL));
    byte datas[]={byte((byte)0x80|(byte)id),posH,posL};
    port.write(datas);
    return 0;
  }
  return -1;
}
int searchSelectedID(){
  int index=(int)servoIDs.getValue();
  int indexcounter=0;
  int selectedid=0;
  for(int i=0;i<32;i++){
    if(busID[i]){
      if(indexcounter==index){
        selectedid=i;
      }
      indexcounter++;
    }
  }
  if(indexcounter==0){
    //println("noID");
    return -1;
  }
  else return selectedid;  
}
void updateIdList(){
  servoIDs.clear();
  for(int i=0;i<32;i++){
    if(busID[i]){
      servoIDs.addItem("ID="+String.valueOf(i),i);
    }
  }
}

int getParam(int id,byte type){
  if(port!=null||type>=5||type==0){
    clearBuf();
    byte datas[]={(byte)((byte)0xA0|(byte)id),type};
    port.write(datas);
    byte readdatas[]={(byte)((byte)0x20|(byte)id),type};
    delay(20);
    if(port.available()<5){
      print("few return");
      return -1;
    }
    for(int i=0;i<2;i++){
      if((byte)port.read()!=datas[i]){
        //print("miss send");
        return -1;
      }
    }
    for(int i=0;i<2;i++){
      if((byte)port.read()!=readdatas[i]){
        //print("miss read");
        return -1;
      }
    }
    return port.read();
  }
  return -1;
}
int getEeprom(int id,byte[] eeprombuf){
  if(port!=null){
    byte datas[]={(byte)((byte)0xA0|(byte)id),(byte)0};
    port.write(datas);
    byte[] buf=new byte[64];
    delay(30);
    if(port.available()<68){
      return -1;      
    }
    for(int i=0;i<4;i++){
      port.read();
    }
    for(int i=0;i<64;i++){
      eeprombuf[i]=(byte)port.read();
    }
    println("ok");
    return 0;
    
  }
  return -1;
}

void setEeprom(int id,byte[] eeprombuf){
  if(port!=null){
    byte datas[]={(byte)((byte)0xC0|(byte)id),(byte)0};
    port.write(datas);
    port.write(eeprombuf);
  }  
}
