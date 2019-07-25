void ask_id(){
  enable_pos.setValue(false);
 if(port!=null){
   clearBuf();
   for(int id=0;id<32;id++){
     byte senddata[]={(byte)((byte)0xA0 | (byte)id),(byte)0x01};
     clearBuf();
     port.write(senddata);
     delay(20);
     if(port.available()==5){
       print("there id ");
        busID[id]=true;
     }
     else {
       print("no id ");
        busID[id]=false;
     }
     println(id);
   }
   updateIdList();
 }
}

void load_eeprom(){
  if(port!=null){
    int id=searchSelectedID();
    byte[] eeprombuf= new byte[64];
    if(getEeprom(id,eeprombuf)==0){
      for(int i=0;i<64;i++){
        eeprom[i].setValue("0x"+hex(eeprombuf[i]));
      }
      //show pos limit
      int posH=((int)eeprombuf[16]<<12)|((int)eeprombuf[17]<<8)|((int)eeprombuf[18]<<4)|(int)eeprombuf[19];
      int posL=((int)eeprombuf[20]<<12)|((int)eeprombuf[21]<<8)|((int)eeprombuf[22]<<4)|(int)eeprombuf[23];
      posLimitH.setValue(posH);
      posLimitL.setValue(posL);
      //at complete load eeprom
      enable_eeprom_edit.unlock();
      overwrite_eeprom.unlock();
    }
    println("hello");
    set_now_pos_D.unlock();
    set_now_pos_U.unlock();
  }
}

void overwrite_eeprom(){
  if(port!=null){
    int id=searchSelectedID();
    byte[] eeprombuf= new byte[64];
    for (int i=0;i<64;i++){
      eeprombuf[i]=(byte)unhex(eeprom[i].getText().split("0x")[1]);
    }
    setEeprom(id,eeprombuf);
  }
  //enable_eeprom_edit.lock();
  //overwrite_eeprom.lock();
}

void set_now_pos_D(){
  int limit=(int)servoPosition.getValue();
  //println(hex(limit));

  for(int i=20;i<24;i++){
    //println(i+" "+hex(limit).substring(i-16,i-15));
    //println(datas[i]);
    eeprom[i].setColorBackground(color(0,135,45))
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(0, 255, 0))
    .setValue("0x0"+hex(limit).substring(i-16,i-15));
  }
}

void set_now_pos_U(){
  int limit=(int)servoPosition.getValue();
  //println(hex(limit));

  for(int i=16;i<20;i++){
    //println(i+" "+hex(limit).substring(i-16,i-15));
    //println(datas[i]);
    eeprom[i].setColorBackground(color(0,135,45))
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(0, 255, 0))
    .setValue("0x0"+hex(limit).substring(i-12,i-11));
  }
}
