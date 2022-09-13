import controlP5.*;

ControlP5 cp5;

Button Start;
Slider Iteration;
Slider StepCount;
Toggle Color;
Toggle Gradual;

int itrationValue;
int currentIterationValue = 0; // reset in start
int stepCounter;

boolean colorButton;// Reset in start
boolean gradualButton; // Reset in start
boolean startButton = false;


float x = 400;
float y = 400;

int step = 1;

void setup() {
    size(800,800);
    background(255, 229, 180);
    
    cp5 = new ControlP5(this);
    Start = cp5.addButton("Start1");
    Start.setPosition(10,10);
    Start.setSize(40,35);
    
    Iteration = cp5.addSlider("Iteration");
    Iteration.setPosition(190,10);
    Iteration.setSize(400,35);
    Iteration.setColorLabel(color(31, 70, 144));
    Iteration.setRange(1000,500000);
    
    StepCount = cp5.addSlider("StepCount");
    StepCount.setPosition(190,70);
    StepCount.setSize(400,35);
    StepCount.setColorLabel(color(31, 70, 144));
    StepCount.setRange(0,10000);
    
    Color = cp5.addToggle("Color");
    Color.setPosition(90,10);
    Color.setSize(40,35);
    Color.setColorLabel(color(31, 70, 144));
    
    Gradual = cp5.addToggle("Gradual");
    Gradual.setPosition(90,70);
    Gradual.setSize(40,35);
    Gradual.setColorLabel(color(31, 70, 144));
}

void Start1() {
    
  println("Start Pressed");

  clear();
  background(255, 229, 180);

  currentIterationValue = 0;
  startButton = false;
  
  if(gradualButton == true){

    startButton = true;
    currentIterationValue = 0;
    
    
  }

  else{
    randomNoGradual();
  }
    
    
}

void Iteration(int value) {
    
    itrationValue = value;
    
    println("Iteration = " + itrationValue);
}

void StepCount(int value) {
    
    stepCounter = value;
    
    println("Step Count = " + stepCounter);
    
}

void Color(boolean value) {
    
    colorButton = value;
    
    println("Color Button = " + colorButton);
    
}

void Gradual(boolean value) {
    
    gradualButton = value;  
    
    println("Gradual Button = " + gradualButton); 
}

public int randomwalk() {
  //Generate a random number
  int walk =(int)random(4);
  /* 
   0=Up
   1=Down
   2=Left
   3=Right
   */
  return walk;
}


public void randomNoGradual() {
  
  int direction =(int)random(4);
  //Go through all the iterations
  for (int i=0; i<itrationValue; i++) {
    //Check if color checkbox is slected.
    if(colorButton == true) {  
      //Change color scale
      stroke((int)map(i,0,itrationValue,0,255));
    }    
    //Switch Case of Direction
    switch(randomwalk()) {
    case 0: 
      //Move Up
      y=y+1;
      //Clump boundary of top of Y
      if (y>800) {
        y=y-1;
        continue;
      } 
      //Plot point
      else {
        point(x, y+1);
        break;
      }
    case 1: 
      //Move Down
      y=y-1;
      //Clump boundary of bottom of Y
      if (y<0) {
        y=y+1;
        continue;
      } 
      //Plot point
      else {
        point(x, y-1);
        break;
      }
    case 2: 
      //Move Left
      x=x-1;
      //Clump boundary of bottom of X
      if (x<0) {
        x=x+1;
        continue;
      } 
      //Plot point
      else {
        point(x-1, y);
        break;
      }
    case 3: 
      //Move Right
      x=x+1; 
      //Clump boundary of top of X
      if (x>800) {
        x=x-1;
        continue;
      } 
      //Plot point
      else {
        point(x+1, y);
        break;
      }
    }
  }
}
public void randomWalkGradual() {  
  //Check if gradual checkbox is slected.
  if(gradualButton == true && startButton == true){
    //Get Step Count stepCounter 
    println("here");
    
    
    //Go through all the iterations
    if(currentIterationValue<itrationValue){
      //Step Count stepCounter per frame
      for(int i=0; i<stepCounter; i++){
        //Check if color checkbox is slected.
        if(colorButton == true){
          //Change color scale
          stroke((int)map(currentIterationValue,0,itrationValue,0,255));
        }
        
        //Switch Case of Direction
        switch(randomwalk()) {
        case 0: 
          //Move Up
          y=y+step;
          //Clump boundary of top of Y
          if (y>800) {
            y=y-step;
          } 
          //Plot point
          else {
            point(x, y+step);
            break;
          }
        case 1: 
          //Move Down
          y=y-step;
          //Clump boundary of bottom of Y
          if (y<0) {
            y=y+step;
          } 
          //Plot point
          else {
            point(x, y-step);
            break;
          }
        case 2: 
          //Move Left
          x=x-step;
          //Clump boundary of bottom of X
          if (x<0) {
            x=x+step;
          } 
          //Plot point
          else {
            point(x-step, y);
            break;
          }
        case 3: 
          //Move Right
          x=x+step; 
          //Clump boundary of top of X
          if (x>800) {
            x=x-step;
          } 
          //Plot point
          else {
            point(x+step, y);
            break;
          }
        }
        //Increment 
        currentIterationValue++;
      }
    }
  }
}

void draw() {

  if(gradualButton == true && startButton == true) 
  
  {

    randomWalkGradual();

  }

}