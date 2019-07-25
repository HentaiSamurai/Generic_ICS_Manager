import processing.serial.*;

import controlP5.*;
import java.util.*;

ControlP5 cp5;

Serial port;

Slider servoPos;
Toggle enable_port;
Toggle enable_pos;
Toggle enable_eeprom_edit;
ScrollableList servoIDs;
ScrollableList servoBoudRate;
Knob servoTemp;
Knob servoCurrent;
Knob servoPosition;
Button overwrite_eeprom;
Button set_now_pos_U;
Button set_now_pos_D;
Slider posLimitH;
Slider posLimitL;

Textfield[] eeprom=new Textfield[64];
String eepromTag[]={"const","const","strc_gain_H","strc_gain_L","spd_H","spd_L","punch_H","punch_L","dedbund_H","dedbund_L","dump_H","dump_L","slfTimer_H","slfTimer_L","flug_H","flug_L","plslm_H_HH","plslm_H_HL","plslm_H_LH","plslm_H_LL"
,"plslm_L_HH","plslm_L_HL","plslm_L_LH","plslm_L_LL","cpnst","const","uartspd_H","uartspd_L","tmplim_H","templim_L","curlim_H","curlim_L","const","const","const","const","const","const","const","const","const","const","const","const","const","const","const","const","const","const"
,"resp_H","resp_L","usroff_H","usroff_L","const","const","id_H","id_L","curstr_1_H","curstr_1_L","curstr_2_H","curstr_2_L","curstr_3_H","curstr_3_L"};

byte selectedPort=0;
byte selectedBaudrate=0;
int baudRates[]={112500,625000,1250000};

boolean[] busID=new boolean[32];

void setup(){
  size(displayWidth,displayHeight);
  
  int dismin=min(width,height);
  
  cp5=new ControlP5(this);
  
  ControlFont cf1 = new ControlFont(createFont("Times",10));
  /*servoPos=cp5.addSlider("Servo Position")
  .setPosition(width/10,height/10*4)
  .setRange(3500,11500)
  .setValue(7500)
  .lock()
  .setFont(cf1)
  .setSize(width/5,height/10/4);*/
  posLimitH=cp5.addSlider("Pos_Limit(up)")
  .setPosition(width/20*2,height/10*4)
  .setRange(3500,11500)
  .setValue(7500)
  .lock()
  .setFont(cf1)
  .setSize(width/5,height/10/4);
  set_now_pos_U=cp5.addButton("set_now_pos_U")
  .setPosition(width/80*3,height/10*4)
  .setValue(7500)
  .lock()
  .setFont(cf1)
  .setSize(width/20,height/10/4);
  posLimitL=cp5.addSlider("Pos_Limit(dw)")
  .setPosition(width/20*2,height/20*9)
  .setRange(3500,11500)
  .setValue(7500)
  .lock()
  .setFont(cf1)
  .setSize(width/5,height/10/4);
  set_now_pos_D=cp5.addButton("set_now_pos_D")
  .setPosition(width/80*3,height/20*9)
  .setFont(cf1)
  .lock()
  .setSize(width/20,height/10/4);
  
  List ports = Arrays.asList(Serial.list());
  
  cp5.addScrollableList("select_port")
     .setPosition(0, 0)
     .setSize(width/10, height/10)
     .setBarHeight(20)
     .setItemHeight(20)
     .setFont(cf1)
     .addItems(ports);
  
  List baudrates=Arrays.asList("115200 bps","625000 bps","1250000 bps");
  cp5.addScrollableList("select_baudrate")
     .setPosition(width/10,0)
     .setSize(width/10, height/10)
     .setBarHeight(20)
     .setItemHeight(20)
     .setFont(cf1)
     .addItems(baudrates);
  /*servoBoudRate=cp5.addScrollableList("servoBoudRate")
     .setPosition(width/10*6,height/2)
     .setSize(width/10, height/10*2)
     .setBarHeight(20)
     .setItemHeight(20)
     .setFont(cf1)
     .lock()
     .addItems(baudrates);*/
  
  enable_port=cp5.addToggle("enable_port")
    .setLabel("enable_Port")
    .setPosition(2*width/10, 0)
    .setFont(cf1)
    .setSize(100, 40);
    
  enable_eeprom_edit=cp5.addToggle("enable_eeprom_edit")
    .setLabel("enable_eeprom_edit")
    .setPosition(4*width/10, height/80*73)
    .setSize(width/20, height/40)
    .setColorBackground(color(135,0,45))
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(255, 0, 0))
    .setFont(cf1)
    .lock();
      
  overwrite_eeprom=cp5.addButton("overwrite_eeprom")
    .setLabel("overwrite_eeprom")
    .setPosition(21*width/40, height/80*73)
    .setSize(width/20, height/40)
    .setColorBackground(color(0,135,45))
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(0, 255, 0))
    .setFont(cf1)
    .lock();
  
  
  cp5.addButton("ask_id")
    .setLabel("Check Online ID")
    .setPosition(2*width/10, 2*height/10)
    .setFont(cf1)
    .setSize(100, 40);
    
  cp5.addButton("load_eeprom")
    .setLabel("load_eeprom")
    .setPosition(37*width/80, 12*height/20)
    .setFont(cf1)
    .setSize(width/20, height/40);
    
  servoIDs=cp5.addScrollableList("online_ID")
     .setPosition(width/10/2,height/10*2)
     .setSize(width/10, height/10)
     .setBarHeight(20)
     .setFont(cf1)
     .setLabel("servoID")
     .setItemHeight(20);
     
  enable_pos=cp5.addToggle("enable_pos")
    .setLabel("enable_Pos_Control")
    .setPosition(width/40*19, height/20*5)
    .setSize(100, 40)
    .setFont(cf1);
    
  servoTemp=cp5.addKnob("temperature") // center knob
            .setRange(0, 127)
            .setValue(0)
            .setPosition(width/40*15, height/10*4)
            .setRadius(dismin/30)
            .setFont(cf1)
            .lock();
            
  servoCurrent=cp5.addKnob("current") // center knob
            .setRange(-63, 63)
            .setValue(0)
            .setPosition(width/40*23, height/10*4)
            .setRadius(dismin/30)
            .setFont(cf1)
            .lock();
  servoPosition=cp5.addKnob("position") // center knob
            .setRange(3500,11500)
            .setValue(0)
            .setPosition(width/40*18, height/10*3)
            .setRadius(dismin/15)
            .setFont(cf1)
            .lock();
  
  for(int i=0;i<64;i++){
    eeprom[i]=cp5.addTextfield(String.valueOf(i+1)+":"+eepromTag[i])
    .setValue("0x00")
    .setPosition(width/20*((int)(i%16)+2),height/20*(13+i/16))
    .setSize(width/30,height/30)
    .setFont(cf1)
    .lock();
  }
  //port = new Serial (this, Serial.list ()[0], baudRates[0],'E',8,1);
}

void draw(){
  background(100);
  delay(10);
  
  int servoid=searchSelectedID();
  
  if(servoPosition.isMousePressed()){//servoPos move by GUI
    if(servoid>=0){
      writePos(servoid,(int)servoPosition.getValue());
    }
  }
  if(servoPosition.isLock()){//servoPos Read
    if(servoid>=0){
      int pos=checkPos(servoid);
      if(pos>=0){
        servoPosition.setValue((float)pos);
      }
    }
  }
  int read=getParam(servoid,(byte)4);//tempread
  if(read>=0){
    servoTemp.setValue((float)read);
  }
  read=getParam(servoid,(byte)3);//currentread
  if(read>=0){
    servoCurrent.setValue((float)(read%64)*pow(-1,read/64));
  }
}

/*void ask_id(){
  if(port!=null){
    byte datas[]={(byte)0xFF,(byte)0x00,(byte)0x00,(byte)0x00};
    clearBuf();
    port.write(datas);
  delay(10);
  if(port.available()<5) {
    println("timeout");
    return;
  }
  for(int i=0;i<4;i++){
    if((byte)port.read()!=datas[i]){
      print("fail to send at ");
      println(i);
      return;
    }
  }
  byte id=(byte)(port.read()&unbinary("00011111"));
  println(id);
  print("ok");
  }
}*/
/*
void serialEvent(Serial p){  
  while(p.available()>0){
    println(hex((byte)p.read()));
  }
}*/
