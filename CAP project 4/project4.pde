import controlP5.*;

ControlP5 cp5;

boolean run=false;
color snow = color(255, 255, 255);
color grass = color(143, 170, 64);
color rock = color(135, 135, 135);
color dirt = color(160, 126, 84);
color water = color(0, 75, 200);


Slider rows1;
Slider columns1;
Slider terrainSize1;
Button generate1;
Toggle stroke1;
Toggle colour1;
Toggle blend1;
Slider heightMod1;
Slider snowThresh1;

Camera cam = new Camera();
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  cam.Zoom(e);
}
void keyReleased(){
  if(key==ENTER){
    generate();
  }
}
void mouseDragged(){
  if(cp5.isMouseOver()){
    return;
  }else{
    float deltaX=(mouseX-pmouseX)*0.01f;
    float deltaY=(mouseY-pmouseY)*0.01f;
    
    cam.phi+=deltaX;
    if(degrees(cam.theta)-degrees(deltaY)>180&&degrees(cam.theta)-degrees(deltaY)<269){
      cam.theta -= deltaY;
    }
  }
}

void setup() {
  background(0);
  size(800, 800, P3D);
  smooth();
  perspective(radians(90), (float)width/(float)height, 0.1, 1000);
  gui();
}
int rows,columns;
float gridSize,heightMod2,snowThresh2;
boolean stroke2, colour2,blend2;
void gui() {
  cp5 = new ControlP5(this);
  rows1 = cp5.addSlider("rows")
     .setPosition(10,10)
     .setSize(150,10)
     .setRange(1,100)
     .setValue(10)
  ;
  columns1 = cp5.addSlider("columns")
     .setPosition(10,30)
     .setSize(150,10)
     .setRange(1,100)
     .setValue(10)
  ;
  terrainSize1 = cp5.addSlider("terrainSize")
     .setPosition(10,50)
     .setSize(150,10)
     .setRange(20,50)
     .setValue(30)
     .setCaptionLabel("terrain size")
  ;
  generate1 = cp5.addButton("generate")
     .setPosition(10,80)
     .setSize(80,20);
  ;
  cp5.addTextfield("filename")
     .setCaptionLabel("load from file")
     .setPosition(10,110)
     .setSize(250,20)
     .setValue("terrain0")
     .setAutoClear(false)
  ;
  stroke1 = cp5.addToggle("stroke")
     .setPosition(300,10)
     .setSize(40,20)
     .setValue(true);
  ;
  colour1 = cp5.addToggle("colour")
     .setPosition(350,10)
     .setSize(40,20)
     .setCaptionLabel("color")
  ;
  blend1 = cp5.addToggle("blend")
     .setPosition(400,10)
     .setSize(40,20)
  ;
  heightMod1 = cp5.addSlider("heightMod")
     .setPosition(300,60)
     .setSize(100,10)
     .setRange(-5,5)
     .setValue(1)
     .setCaptionLabel("height modifier")
  ;
  snowThresh1 = cp5.addSlider("snowThresh")
     .setPosition(300,80)
     .setSize(100,10)
     .setRange(1,5)
     .setValue(5)
     .setCaptionLabel("snow threshold")
  ;
}
void rows(int theValue) {rows = theValue;}
void columns(int theValue) {columns = theValue;}
void terrainSize(float val){gridSize = val;}
void stroke (boolean val){stroke2 = val;}
void colour (boolean val){colour2 = val;}
void blend (boolean val){blend2 = val;}
void heightMod (float val){heightMod2 = val;}
void snowThresh(float val){snowThresh2 = val;}


Grid grid = null;
PImage heightmap = null;
void generate(){
  grid=null;
  grid = new Grid();
  heightmap=null;
  heightmap = loadImage("data/"+cp5.get(Textfield.class,"filename").getText()+".png");
  grid.generateHeight();
  
  run=true;
}

void draw() {
  background(0);
  cam.Update();
  perspective(radians(90), (float)width/(float)height, 0.1, 1000);
  camera(cam.camX, cam.camY, cam.camZ, cam.lookAtX, cam.lookAtY, cam.lookAtZ, 0, 1, 0);
  
  if(run==true){
    grid.Draw();
  }
  

  
  camera();
  perspective();
}

class Camera{
  float camX;
  float camY;
  float camZ;
  float radius;
  float theta;
  float phi;
  float lookAtX;
  float lookAtY;
  float lookAtZ;
  void Update(){
    camX = radius*cos(phi)*sin(theta)+lookAtX;
    camY = radius*cos(theta)+lookAtY;
    camZ = radius*sin(theta)*sin(phi)+lookAtZ;
  }
  void Zoom(float zoomFac){
    if(zoomFac>0){//scrolling down
      if(radius<200){
        radius+=5;
      }
    }else if(zoomFac<0){
      if(radius>10){
        radius-=5;
      }
    }
  }
  Camera(){
    theta = 5.5*PI/4;
    phi = 3*PI/2;
    radius = 15;//10-200
    lookAtX = 0;
    lookAtY = 0;
    lookAtZ = 0;
  }
}

class Grid{

  ArrayList<PVector> vertdata;
  ArrayList<Integer> tridata;
  Grid(){
    
    vertdata=new ArrayList<PVector>();
    tridata=new ArrayList<Integer>();
    generateVerts();
    generateTris();
  }
  void generateVerts(){
    float rtemp = -gridSize/2;
    for(int r=0;r<=rows;r++){
      float ctemp = -gridSize/2;
      for(int c=0;c<=columns;c++){
        vertdata.add(new PVector(ctemp,0,rtemp));
        ctemp+=gridSize/columns;
      }
      rtemp+=gridSize/rows;
    }
  }
  void generateTris(){
    int verticesrow=columns+1;
    for(int r=0;r<rows;r++){
      for(int c=0;c<columns;c++){
        int startIndex=r*verticesrow+c;
        tridata.add(startIndex);
        tridata.add(startIndex+1);
        tridata.add(startIndex+verticesrow);
        
        tridata.add(startIndex+1);
        tridata.add(startIndex+verticesrow+1);
        tridata.add(startIndex+verticesrow);
      }
    }
  }
  void generateHeight(){
    for(int r=0;r<=rows;r++){
      for(int c=0;c<=columns;c++){
        float x_index=map(c,0,columns+1,0,heightmap.width);
        float y_index=map(r,0,rows+1,0,heightmap.height);
        int colour=heightmap.get(int(x_index),int(y_index));
        
        float heightFromColor=map(red(colour),0,255,0,1.0f);
        
        int vertex_index = r*(columns+1)+c;
        vertdata.get(vertex_index).y=-heightFromColor;
      }
    }
  }
  void Draw(){
    if(stroke2){
      stroke(0);
    }
    else{
      noStroke();
    }

    fill(255,255,255);
    beginShape(TRIANGLES);
    for(int i=0;i<tridata.size();i++){
      int vertIndex = tridata.get(i);
      PVector vert=vertdata.get(vertIndex);
      
      if(colour2){//if color is on
        float relativeHeight=abs(vert.y)*heightMod2/snowThresh2;
        if(0.8<relativeHeight){
          if(blend2){
            float ratio=(relativeHeight-0.8f)/0.2f;
            fill(lerpColor(rock,snow,ratio));
          }
          else{
            fill(snow);
          }
        }
        if(0.4<relativeHeight&&relativeHeight<0.8){
          if(blend2){
            float ratio=(relativeHeight-0.4f)/0.4f;
            fill(lerpColor(grass,rock,ratio));
          }
          else{
            fill(rock);
          }
        }
        if(0.2<relativeHeight&&relativeHeight<0.4){
          if(blend2){
            float ratio=(relativeHeight-0.2f)/0.2f;
            fill(lerpColor(dirt,grass,ratio));
          }
          else{
            fill(grass);
          }
        }
        else if(relativeHeight<0.2){
          if(blend2){
            float ratio=relativeHeight/0.2f;
            fill(lerpColor(water,dirt,ratio));
          }
          else{
            fill(water);
          }
        }
      }
      
      vertex(vert.x,vert.y*heightMod2,vert.z);
    }
    endShape();
  }
}
