void clearBuf(){
  if(port!=null){
    while(port.available()>0){
      port.read();
    }
  }
}
void changeSerialPort(){//change serialPort by selectedParam
if(port!=null&&enable_port.getState()){
  port.stop();
  port=null;
}
if(enable_port.getState()){
  port = new Serial (this, Serial.list ()[selectedPort], baudRates[selectedBaudrate],'E',8,1);
  println("enable port");
}
}
