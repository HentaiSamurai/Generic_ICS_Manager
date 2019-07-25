void select_port(int n){
  selectedPort=(byte)n;
  changeSerialPort();
}
void select_baudrate(int n){
  selectedBaudrate=(byte)n;
  changeSerialPort(); 
}

void online_ID(int n){
  println("now");
  enable_pos.setValue(false);
  set_now_pos_D.lock();
  set_now_pos_U.lock();
  enable_eeprom_edit.setValue(false)
  .lock();
  overwrite_eeprom.lock();
}
