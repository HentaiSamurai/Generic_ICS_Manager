void enable_pos(boolean u){
  if(u) {
    //servoPos.unlock();
    servoPosition.unlock();
  }
  else servoPosition.lock();
}
void enable_port(){
  if(! enable_port.getState() && port!=null){
    port.stop();
    port=null;
  }
  else if(enable_port.getState()){
    changeSerialPort(); 
  }
}
void enable_eeprom_edit(boolean u){
  if(enable_eeprom_edit.getState()){
    for(int i=0;i<64;i++){
      if(eepromTag[i]!="const"){
        eeprom[i].setColorBackground(color(135,0,45))
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(255, 0, 0))
    .unlock();
      }
    }
  }
  else{
    for(int i=0;i<64;i++){
      if(eepromTag[i]!="const"){
        eeprom[i].setColorBackground(color(0,45,90))
        .setColorActive(color(0, 170, 255))
        .setColorForeground(color(0, 116, 217))
        .lock();
      }
    }
  }
}
