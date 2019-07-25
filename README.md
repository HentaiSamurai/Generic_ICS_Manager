# Generic_ICS_Manager
get start  
  
1.install processing3 at https://processing.org/  
2.open ICS_Manager/ICS_Manager.pde  
3.install ControlP5 (at sketch->import library->add library,search  "ControlP5",install  
![screenshot](https://github.com/HentaiSamurai/Generic_ICS_Manager/blob/images/installCP5.png)  
4.run sketch  

how to use  

1.connect your USB-uart and check portname eg:"COM10"  
2.run sketch  
3.select portname and baudrate of target servo  
4.push "ENABLE_PORT" button  
5.push "CHECK ONLINE ID"button  
6.select target ID  
7.centor knob "POSITION","TEMPRATURE"and"CURRENT" moniter param in realtime  
8.push "ENABLE_POS_CONTROL" button,you can control servo position by centor knob  
9.push again "ENABLE_POS_CONTROL",servo be free  
10.push "LOAD_EEPROM" button,display eeprom information  
11.push "ENABLE_EEPROM_EDIT" button,some eeprom box color change to red.red color box can be edit.  
12.push "SET_NOW_POS_U/D"button, set eeprom information to nowposition to set limitter(UP/DOWN)  
13.push "OVERWRITE_EEPROM" button ,servo eeprom write by box information.  
![howtouse](https://github.com/HentaiSamurai/Generic_ICS_Manager/blob/images/howToUse.png)
