PVector lookatTarget = new PVector(0, 0, 0); // in my project -> lookatTarget
PVector cameraPosition = new PVector(0, 0, 0);
boolean whealSpun = false;
boolean spaceBar = true;
int targetNum = 0;
int scale = 0;
int radius;
float x,y,z,theta,phi,zoom;

PShape cube1;
PShape monstor1;
PShape monstor2;
PShape largeFan;
PShape smallFan;
cam camObj = null;
cubes cubeObj = null;
fan fanObject = null;
grid gridObj = null;
monstor mostorObj = null;

int color1 = 0;


public void setup() {

  size(1600, 1000, P3D);

  // tried perspective(radians(50.0f), width/(float)height, 0.1, 1000);
  // but the everything was inverted so -radians(50.0f)
  perspective(-radians(50.0f), width / (float) height, 0.1, 1000);
  translate(width * 0.5, height * 0.5, 0);
 
  camObj = new cam();
  fanObject = new fan();
  cubeObj = new cubes();
  gridObj = new grid();
  mostorObj = new monstor();

}
public void draw() {

  colorMode(RGB, 255);
  background(155);

  gridObj.Update();

  mostorObj.Update();

  cubeObj.Update();

  fanObject.Update();

  camObj.Update();
}


public class grid {
  public void grid() {}

  public void Update() {
    pushMatrix();

    for (int i = 0; i < 21; i++) {

      stroke(255);
      line(-100, 0, -100 + 10 * i, 100, 0, -100 + 10 * i);
      line(-100+10*i, 0, -100, -100+10*i, 0, 100);
    }


    stroke(255, 0, 0);
    line(-100, 0, 0, 100, 0, 0);

    stroke(0, 0, 255);
    line(0, 0, -100, 0, 0, 100);
    popMatrix();

  }
}


public void keyPressed() {
  if (key == 32) {
    spaceBar = true;

    println("space pressed");
  }
}

// Check if mouse wheel is moved
public void mouseWheel(MouseEvent event) {
  whealSpun = true;
  scale = event.getCount();
}

// Camera class
public class cam {
  // Global Variable
  
  float scaleFactor = 0;
  int radius = 200;
  float zoom = 1;

  // Constructor
  public void cam() {}

  public void Update() {
    // Update Target and Zoom
    CycleTarget();
    // Map mouse position
    theta = radians(map(mouseY, 0, width - 1, 0, 360));
    phi = radians(map(mouseX, 0, height - 1, 1, 179));
    // Camera Positions
    cameraPosition.x = lookatTarget.x + radius * cos(phi) * sin(theta);
    cameraPosition.y = lookatTarget.y + radius * cos(theta);
    cameraPosition.z = lookatTarget.z + radius * sin(theta) * sin(phi);

    camera(cameraPosition.x * abs(Zoom(scale)),
        cameraPosition.y * abs(Zoom(scale)),
        cameraPosition.z * abs(Zoom(scale)), // Where is the camera?
        lookatTarget.x, lookatTarget.y,
        lookatTarget.z, // Where is the camera looking?
        0, 1, 0); // Camera Up vector (0, 1, 0 often, but not always, works)
  }

  public void AddLookAtTarget(PVector lookatTarget) {

    lookatTarget.mult(0);
    // Reset counter to beginning
    if (targetNum >= 5) {
      targetNum = 1;
    }

    if (targetNum == 1) {
      lookatTarget.add(-100, 0, 0);
    }

    if (targetNum == 2) {
      lookatTarget.add(-50, 0, 0);
    }
    if (targetNum == 3) {
      lookatTarget.add(0, 0, 0);
    }
    if (targetNum == 4) {
      lookatTarget.add(75, 0, 0);
    }
  };

  public void CycleTarget() {
    if (spaceBar) {
      AddLookAtTarget(lookatTarget);
      // Item counter
      targetNum++;
      spaceBar = false;
    }
  };

  public float Zoom(float scale) {
    if (whealSpun) {
      zoom += scale * 0.2;
      whealSpun = false;
      
      print("wheel moved");
      return zoom;
    } else {
      return zoom;
    }
  };
}


public class monstor {
  public void monstor() {}
  public void Update() {
 

   
    pushMatrix();

    initLargeMonstor();

    initSmallMonstor();

    popMatrix();
  }

  public void initLargeMonstor() {
    monstor1 = loadShape("monster.obj");

    monstor1.setFill(true);
    monstor1.setFill(color(0, 0, 0, 0)); 
    monstor1.setStroke(true);
    monstor1.setStroke(color(0));
    monstor1.setStrokeWeight(1.5f);
    monstor1.scale(1, 1, -1); 
    monstor1.translate(75, 0, 0); 
    shape(monstor1);
  }

  public void initSmallMonstor() {
    monstor2 = loadShape("monster.obj");

    monstor2.setStroke(true);
    monstor2.setStroke(color(190, 230, 60)); 
    monstor2.setFill(true);
    monstor2.setFill(color(190, 230, 60));
    monstor2.translate(0, 0, 0); 
    monstor2.scale(0.5);
    shape(monstor2);
  }
}


public class cubes {
  public void cubes() {}

  public void Update() {

    translate(-100, 0, 0);

    pushMatrix();
    translate(-10, 0, 0);
    initcube();
    shape(cube1, 0, 0);
    popMatrix();

    pushMatrix();
    scale(5, 5, 5);
    shape(cube1, 0, 0);
    popMatrix();


    pushMatrix();
    translate(10, 0, 0);
    scale(10, 20, 10);
    shape(cube1, 0, 0);
    popMatrix();


    translate(100, 0, 0);
  }


  public void initcube() {
    cube1 = createShape();

    cube1.beginShape(TRIANGLE_STRIP);
    cube1.noStroke();

    cube1.fill(255, 255, 0); 
    cube1.vertex(-0.5, -0.5, -0.5);
    cube1.vertex(-0.5, 0.5, -0.5);
    cube1.vertex(0.5, -0.5, -0.5);
    cube1.fill(0, 255, 0);
    cube1.vertex(-0.5, 0.5, -0.5);
    cube1.vertex(0.5, -0.5, -0.5);
    cube1.vertex(0.5, 0.5, -0.5);

    cube1.fill(160, 60, 179); 
    cube1.vertex(-0.5, -0.5, 0.5);
    cube1.vertex(-0.5, 0.5, 0.5);
    cube1.vertex(0.5, 0.5, 0.5);
    cube1.fill(0, 128, 200); 
    cube1.vertex(-0.5, -0.5, 0.5);
    cube1.vertex(0.5, 0.5, 0.5);
    cube1.vertex(0.5, -0.5, 0.5);

    cube1.fill(160, 209, 182); 
    cube1.vertex(0.5, 0.5, 0.5);
    cube1.vertex(-0.5, 0.5, 0.5);
    cube1.vertex(0.5, 0.5, -0.5);
    cube1.fill(247, 107, 0); 
    cube1.vertex(-0.5, 0.5, 0.5);
    cube1.vertex(0.5, 0.5, -0.5);
    cube1.vertex(-0.5, 0.5, -0.5);
 
    cube1.fill(254, 60, 39); 
    cube1.vertex(0.5, 0.5, 0.5);
    cube1.vertex(0.5, -0.5, 0.5);
    cube1.vertex(0.5, 0.5, -0.5);
    cube1.fill(75, 128, 199); 
    cube1.vertex(0.5, -0.5, 0.5);
    cube1.vertex(0.5, 0.5, -0.5);
    cube1.vertex(0.5, -0.5, -0.5);

    cube1.fill(254, 0, 0); 
    cube1.vertex(-0.5, -0.5, 0.5);
    cube1.vertex(0.5, -0.5, 0.5);
    cube1.vertex(0.5, -0.5, -0.5);
    cube1.fill(250, 2, 251); 
    cube1.vertex(-0.5, -0.5, 0.5);
    cube1.vertex(-0.5, -0.5, -0.5);
    cube1.vertex(0.5, -0.5, -0.5);

    cube1.fill(102, 102, 222); 
    cube1.vertex(-0.5, 0.5, 0.5);
    cube1.vertex(-0.5, -0.5, 0.5);
    cube1.vertex(-0.5, -0.5, -0.5);
    cube1.fill(180, 180, 150); 
    cube1.vertex(-0.5, 0.5, 0.5);
    cube1.vertex(-0.5, -0.5, -0.5);
    cube1.vertex(-0.5, 0.5, -0.5);
    cube1.endShape();
  }
}

public class fan {
  public void fan() {}

  public void Update() {
    translate(-50, 0, 0);
    scale(-1, 1, 1);

    pushMatrix();
    initSmallFan();
    shape(smallFan);

    initLargeFan();
    shape(largeFan);
    popMatrix();
  }

  public void initLargeFan() {
    largeFan = createShape();

    translate(20, 0, 0);
    color1 = 0;
    
    colorMode(HSB, 360, 100, 100);
    largeFan.beginShape(TRIANGLE_FAN);
    largeFan.setStroke(true);


    largeFan.fill(color(color1, 100, 100)); 
    largeFan.vertex(0, 10, 0);
    for (float angle = 0; angle <= 360; angle += 360 / 20) {
      float vertexX = 10 + cos(radians(angle)) * 10;
      float vertexY = 10 + sin(radians(angle)) * 10;

      color1 += 360 / 20;
      largeFan.fill(color(color1, 100, 100)); 
      largeFan.vertex(vertexX, vertexY);
    }
    
    largeFan.endShape();
  }

  public void initSmallFan() {
    smallFan = createShape();

    translate(-10, 0, 0);
    color1 = 0;
  
    colorMode(HSB, 360, 100, 100);
    smallFan.beginShape(TRIANGLE_FAN);
    smallFan.setStroke(true);


    smallFan.fill(color(color1, 100, 100)); 
    smallFan.vertex(0, 10, 0);
    for (float angle = 0; angle <= 360; angle += 360 / 6) {
      float vertexX = 10 + cos(radians(angle)) * 10;
      float vertexY = 10 + sin(radians(angle)) * 10;

      color1 += 360 / 6;
      smallFan.fill(color(color1, 100, 100)); 
      smallFan.vertex(vertexX, vertexY);
    }
   
    smallFan.endShape();
  }
}
