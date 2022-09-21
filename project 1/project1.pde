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

boolean colorButton; // Reset in start
boolean gradualButton; // Reset in start
boolean startButton = false;

float x = 400;
float y = 400;

int step = 1;

void setup() {
  size(800, 800);
  background(255, 229, 180);

  cp5 = new ControlP5(this);
  Start = cp5.addButton("Start1");
  Start.setPosition(10, 10);
  Start.setSize(40, 35);
  Start.setCaptionLabel("Start");

  Iteration = cp5.addSlider("Iteration");
  Iteration.setPosition(190, 10);
  Iteration.setSize(400, 35);
  Iteration.setColorLabel(color(31, 70, 144));
  Iteration.setRange(1000, 500000);
  Iteration.setCaptionLabel("Iteration");

  StepCount = cp5.addSlider("StepCount");
  StepCount.setPosition(190, 70);
  StepCount.setSize(400, 35);
  StepCount.setColorLabel(color(31, 70, 144));
  StepCount.setRange(1, 10000);
  StepCount.setCaptionLabel("Step Count");

  Color = cp5.addToggle("Color");
  Color.setPosition(90, 10);
  Color.setSize(40, 35);
  Color.setColorLabel(color(31, 70, 144));

  Gradual = cp5.addToggle("Gradual");
  Gradual.setPosition(90, 70);
  Gradual.setSize(40, 35);
  Gradual.setColorLabel(color(31, 70, 144));
}

void Start1() {

  println("Start Pressed");

  

  background(255, 229, 180);

  stroke(24, 24, 24);

  currentIterationValue = 0;
  startButton = false;

  x = 400;
  y=400;

  if (gradualButton == true) {
    startButton = true;
    currentIterationValue = 0;

  }

  else {
    startButton = false;
    
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

void walk() {
  int direction = (int) random(4);

  if (direction == 0) {
    y = y + step;

    if (y > 800) {
      y = y - 1;
    }

   
      point(x, y);
  
  }
  if (direction == 1) {
    y = y - 1;

    if (y < 0) {
      y = y + 1;
    }

    
      point(x, y);
    
  }
  if (direction == 2) {
    x = x - 1;

    if (x < 0) {
      x = x + 1;
    }

    
      point(x, y);
    
  }

  if (direction == 3) {
    x = x + 1;

    if (x > 800) {
      x = x - 1;
    }

    
      point(x , y);
  
  }
}


public void randomNoGradual() {
  
  for (int i = 0; i < itrationValue; i++) {
    

    if (colorButton == true) {
      
      stroke((int) map(i, 0, itrationValue, 0, 255));
    }

    walk();
  }
}


public void randomWalkGradual() {
  if (gradualButton == true && startButton == true) {
    if (currentIterationValue < itrationValue) {
      for (int i = 0; i < stepCounter; i++) {
        if (colorButton == true) {
          stroke((int) map(currentIterationValue, 0, itrationValue, 0, 255));
        }

        walk();

        currentIterationValue++;
      }
    }
  }
}

void draw() {


  if (gradualButton == true && startButton == true)

  {
    randomWalkGradual();
  }

  if(gradualButton == false && startButton == false){
    randomNoGradual();
  }
}