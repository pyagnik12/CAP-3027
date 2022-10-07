import controlP5.*;
ControlP5 cp5;

//UI elements

Button start;
DropdownList dropdownList;
Slider maxStep;
Slider stepRate1;
Slider stepSize1;
Slider stepScale1;
Toggle box;
Toggle box1;
Toggle box2;
Toggle box3;
Textfield text;




//UI extracted variables
boolean startButton;
int shape,max,stepRate,stepSize;
boolean constrainStepsButton,simulateButton;
boolean strokeButton,randomButton;
int seedValue;
double stepScale;
int seed;

// my variables
int x,y;
float tx,ty;
int count,temp;

HashMap<PVector, Integer> map = new HashMap();

void setup(){

    size(1200,800);
    background(color(187, 222, 214));
    noStroke();
    
    fill(color(97, 192, 191));
    rect(0,0,400,800);

    cp5 = new ControlP5(this);

    start = cp5.addButton("Start1");
    start.setPosition(40,40);
    start.setColorBackground(color(187, 222, 214));
    start.setColorLabel(color(23, 70, 162));
    start.setSize(200,50);
    start.getCaptionLabel().setSize(12);

    dropdownList = cp5.addDropdownList("dropDown");
    dropdownList.addItem("Squares",0);

    dropdownList.addItem("Hexagons",1);
    dropdownList.setItemHeight(40);
    dropdownList.setBarHeight(35);
    dropdownList.setPosition(40,100);
    dropdownList.setOpen(false);
    dropdownList.setColorBackground(color(187, 222, 214));
    dropdownList.setColorLabel(color(23, 70, 162));
    dropdownList.setSize(150,300);
    dropdownList.getCaptionLabel().setSize(12);

    maxStep = cp5.addSlider("maxStep");
    maxStep.setPosition(40,270);
    maxStep.setSize(150,50);
    maxStep.setCaptionLabel("Maximum Steps");
    maxStep.setColorBackground(color(187, 222, 214));
    maxStep.setColorLabel(color(23, 70, 162));
    maxStep.setRange(100,5000);
    maxStep.getCaptionLabel().setSize(12);


    stepRate1 = cp5.addSlider("stepRate1");
    stepRate1.setPosition(40,340);
    stepRate1.setSize(150,50);
    stepRate1.setCaptionLabel("Step Rate");
    stepRate1.setColorBackground(color(187, 222, 214));
    stepRate1.setColorLabel(color(23, 70, 162));
    stepRate1.setRange(1,1000);
    stepRate1.getCaptionLabel().setSize(12);

    stepSize1 = cp5.addSlider("stepSize1");
    stepSize1.setPosition(40,410);
    stepSize1.setSize(150,50);
    stepSize1.setCaptionLabel("Step Size");
    stepSize1.setColorBackground(color(187, 222, 214));
    stepSize1.setColorLabel(color(23, 70, 162));
    stepSize1.setRange(10,30);
    stepSize1.getCaptionLabel().setSize(12);

    stepScale1 = cp5.addSlider("stepScale1");
    stepScale1.setPosition(40,470);
    stepScale1.setSize(150,50);
    stepScale1.setCaptionLabel("Step Scale");
    stepScale1.setColorBackground(color(187, 222, 214));
    stepScale1.setColorLabel(color(23, 70, 162));
    stepScale1.setRange(1.0,1.5);
    stepScale1.getCaptionLabel().setSize(12);

    box = cp5.addToggle("constrainSteps");
    box.setPosition(40,530);
    box.setSize(35,35);
    box.setCaptionLabel("Constrain Step");
    box.setColorBackground(color(187, 222, 214));
    box.setColorLabel(color(23, 70, 162));
    box.getCaptionLabel().setSize(12);

    box1 = cp5.addToggle("simulateTerrain");
    box1.setPosition(40,580);
    box1.setSize(35,35);
    box1.setCaptionLabel("Simulate Terrain");
    box1.setColorBackground(color(187, 222, 214));
    box1.setColorLabel(color(23, 70, 162));
    box1.getCaptionLabel().setSize(12);

    box2 = cp5.addToggle("useStroke");
    box2.setPosition(40,630);
    box2.setSize(35,35);
    box2.setCaptionLabel("Use Stroke");
    box2.setColorBackground(color(187, 222, 214));
    box2.setColorLabel(color(23, 70, 162));
    box2.getCaptionLabel().setSize(12);

    box3 = cp5.addToggle("useRandomSeed");
    box3.setPosition(40,680);
    box3.setSize(35,35);
    box3.setCaptionLabel("Use Random Seed");
    box3.setColorBackground(color(187, 222, 214));
    box3.setColorLabel(color(23, 70, 162));
    box3.getCaptionLabel().setSize(12);

    text = cp5.addTextfield("seedValue");
    text.setPosition(150,680);
    text.setInputFilter(ControlP5.INTEGER);
    text.setColorBackground(color(187, 222, 214));
    text.setColorLabel(color(23, 70, 162));
    text.setSize(50,35);
    text.getCaptionLabel().setSize(12);
}
void Start1(){
    println("Start pressed");

    // reset stuff
    temp = 0;
    x = 600;
    y = 400;

    tx= 600;
    ty = 400;

    count = 0;
    map.clear();

    startButton  = true;

    background(color(187, 222, 214));
    noStroke();

    fill(color(97, 192, 191));
    rect(0,0,400,800);

    if(randomButton == true){
        randomSeed(seed);
    }
    
}

void dropDown(int type){

    shape = type;

    if(shape == 1){
    
        println("Shape: Square Code: " + shape);
    
    }

    else{
        println("Shape: Hexagons Code:"+ shape);
    }
}

void maxStep(int value){

    max = value;

    println("Max step: " + max);
}

void stepRate1(int value){

    stepRate = value;

    println("Step Rate: " + stepRate);

}

void stepSize1(int value){

    stepSize = value;

    println("Step Size: " + stepSize);
}
void stepScale1(int value){

    stepScale = (double) value;
    println("Step Scale: " + stepScale);
}
void constrainSteps(boolean value){

    constrainStepsButton = value;
    println("Constrained steps: " + value);
}

void simulateTerrain(boolean value){

    simulateButton = value;
    println("Simulated terrain: " + simulateButton);
}

void useStroke(boolean value){

    strokeButton = value;

    println("Stroke: " + strokeButton);
}

void useRandomSeed(boolean value){

    randomButton = value;
    println("Random seed: " + randomButton);
}

void seedValue(String value){

    seedValue = (int)Integer.parseInt(value);
    println("Seed: " + seedValue);
}

RandomWalkBase object = null;

class RandomWalkBase{

    public int walkSquare() {
        //Generate a random number
        int walk =(int)random(4);
        //0=Up  1=Down  2=Left  3=Right
        return walk;
    }

}
class square extends RandomWalkBase{
    int step = (int)(stepSize*stepScale);
    int xbound = 0;

    public square() {

        if(constrainStepsButton == true){
            xbound = 400;
        }

        if(!simulateButton){
            fill(255,0,255);
        }
        Draw();
    }
    
    void Draw() {


        if(temp < max){
            for(int i = 0; i < stepRate; i++){
                if(strokeButton){
                    stroke(2);
                }

                switch (walkSquare()) {

                    case 0:

                        y = y+ step;

                        if(y > 800){
                            y = y-step;
                        }
                        else{
                            col(temp,x,y);
                            square(x,y,stepSize);
                            break;
                        }
                
                    case 1:

                        y = y - step;

                        if(y < 0){
                            y = y+step;
                        }

                        else{
                            col(temp,x, y);
                            square(x,y, stepSize);
                            break;
                        }

                    case 2:
                         
                        x=x-step;
                        
                        if (x<xbound) {
                            x=x+step;
                        } 
                        //Plot point
                        else {
                            col(temp, x, y);
                            square(x, y, stepSize);
                            break;
                        }
                    case 3:
                    x = x+step;
                    if(x > 1200){
                        x= x-step;
                    }
                    else{
                        col(temp,x,y);
                        square(x,y, stepSize);
                        break;
                    }

                }

                temp++;

                if(temp == max){
                    startButton = false;
                }

            }
        }

    }
}



public void col (int temp, int x, int y){
    if(simulateButton){
      PVector vector = new PVector(Math.round(x*100)/100.00, Math.round(y*100)/100.00);

      if(map.get(vector) == null){
        map.put(vector,1);
      }  

      else{
        count = map.get(vector);
        map.put(vector,++count);
      }

      if(count < 4){
        fill(160,126,84);
      }
      else if (4<count && count< 7) {    //grass
        fill(143, 170, 64);
      } else if (7<count && count< 10) {    //rock
        fill(135, 135, 135);
      } else {  //snow
        fill(count*20, count*20, count*20);
      }
    }
}
void shapeSelector() {

    if(shape == 0)
    {
        object = new square();
    }

    // else{
    //     object = new hexagon();
    // }

}
//main function
void draw(){

    if(startButton == true){
        shapeSelector();
    }
}
