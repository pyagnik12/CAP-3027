/*

Note to future Parth:
When I wrote the code only
me and God knew what I wrote

Now only God will remember
what I wrote

*/

import controlP5.*;

ControlP5 cp5;

// set up variables
boolean run = false;

// color consts
color johnSnow = color(255, 255, 255); // this refers to color for snow
color grass = color(143, 170, 64);
color dwaneTheRock = color(135, 135, 135); // this refers to color for rock
color dirt = color(160, 126, 84);
color water = color(0, 75, 200);

// p5 variables
Slider rows1;
Slider columns1;
Slider terrainSize1;
Button generate1;
Toggle stroke1;
Toggle colour1;
Toggle blend1;
Slider heightMod1;
Slider snowThresh1;

// cam init
Camera cam = new Camera();

void setup() {
  background(0);

  size(1200, 800, P3D);

  smooth();

  /*
  from the project pdf --------------------------------
  The perspective() function uses the
  same near and far values of 0.1 and 1000.0,
  respectively, while the fov is set
  to 90 degrees (converted to radians when
  actually being used in the perspective() function).
  */

  perspective(radians(90), (float) width / (float) height, 0.1, 1000);

  cp5 = new ControlP5(this);
  rows1 = cp5.addSlider("rows")
              .setPosition(10, 10)
              .setSize(150, 10)
              .setRange(1, 100)
              .setValue(10);
  columns1 = cp5.addSlider("columns")
                 .setPosition(10, 30)
                 .setSize(150, 10)
                 .setRange(1, 100)
                 .setValue(10);
  terrainSize1 = cp5.addSlider("terrainSize")
                     .setPosition(10, 50)
                     .setSize(150, 10)
                     .setRange(20, 50)
                     .setValue(30)
                     .setCaptionLabel("terrain size");
  generate1 = cp5.addButton("generate").setPosition(10, 80).setSize(80, 20);
  ;
  cp5.addTextfield("filename")
      .setCaptionLabel("load from file")
      .setPosition(10, 110)
      .setSize(250, 20)
      .setValue("terrain0")
      .setAutoClear(false);
  stroke1 =
      cp5.addToggle("stroke").setPosition(300, 10).setSize(40, 20).setValue(
          true);
  ;
  colour1 = cp5.addToggle("colour")
                .setPosition(350, 10)
                .setSize(40, 20)
                .setCaptionLabel("color");
  blend1 = cp5.addToggle("blend").setPosition(400, 10).setSize(40, 20);
  heightMod1 = cp5.addSlider("heightMod")
                   .setPosition(300, 60)
                   .setSize(100, 10)
                   .setRange(-5, 5)
                   .setValue(1)
                   .setCaptionLabel("height modifier");
  snowThresh1 = cp5.addSlider("snowThresh")
                    .setPosition(300, 80)
                    .setSize(100, 10)
                    .setRange(1, 5)
                    .setValue(5)
                    .setCaptionLabel("Snow threshold");
}

// p5 data extraction variables
int rows, columns;
float gridSize, heightMod2, snowThresh2;
boolean stroke2, colour2, blend2;

// draw variables
float ratio, relativeHeight;

PVector vertexData;

// cam stuff ideas
// float camX,camY, camZ,radius,theta,phi,lookAtX,lookAtY,lookAtZ;
void gui() {}
void rows(int val) {
  rows = val;

  println("The rows value is" + rows);
}
void columns(int val) {
  columns = val;

  println("The columns value is" + columns);
}
void terrainSize(float val) {
  gridSize = val;

  println("The grid size value is" + gridSize);
}
void stroke(boolean val) {
  stroke2 = val;
  println("The stroke value is" + stroke2);
}
void colour(boolean val) {
  colour2 = val;
  println("The colour value is" + colour2);
}
void blend(boolean val) {
  blend2 = val;

  println("The blend value is" + blend2);
}
void heightMod(float val) {
  heightMod2 = val;

  println("The height is" + heightMod2);
}

void snowThresh(float val) {
  snowThresh2 = val;

  println("The snow is" + snowThresh2);
}

// init grid
Grid grid = null;
PImage heightmap = null;
void generate() {
  grid = null;
  grid = new Grid();
  heightmap = null;
  heightmap = loadImage(
      "data/" + cp5.get(Textfield.class, "filename").getText() + ".png");
  grid.generateHeight();

  run = true;
}

// The OG draw function
void draw() {
  background(0);

  cam.Update();

  perspective(radians(90), (float) width / (float) height, 0.1, 1000);
  camera(cam.camX, cam.camY, cam.camZ, cam.lookAtX, cam.lookAtY, cam.lookAtZ, 0,
      1, 0);

  if (run == true) {
    grid.Render();
  }

  camera();
  perspective();
}

class Camera {
  float camX;
  float camY;
  float camZ;
  float radius;
  float theta;
  float phi;
  float lookAtX;
  float lookAtY;
  float lookAtZ;
  void Update() {
    camX = radius * cos(phi) * sin(theta) + lookAtX;
    camY = radius * cos(theta) + lookAtY;
    camZ = radius * sin(theta) * sin(phi) + lookAtZ;
  }
  void Zoom(float scale) {
    if (scale > 0) { // scrolling down
      if (radius < 200) {
        radius += 5;
      }
    } else if (scale < 0) {
      if (radius > 10) {
        radius -= 5;
      }
    }
  }
  Camera() {
    theta = 5.5 * PI / 4;
    phi = 3 * PI / 2;
    radius = 15;
    lookAtX = 0;
    lookAtY = 0;
    lookAtZ = 0;
  }
}

class Grid {
  float xIdx, yIdx, heightFromColor;

  int colour, vertIdx, startIndex;
  ArrayList<PVector> vertex;
  ArrayList<Integer> trianglesData;
  Grid() {
    vertex = new ArrayList<PVector>();
    trianglesData = new ArrayList<Integer>();
    generateVertex();
    generateTriangle();
  }
/*
from the project pdf --------------------------------
for (i <= rows)
{
 for (j <= columns)
 {
 // rows/columns +1 because there are more vert columns than polygon columns
 x_index = map j from 0  columns+1 to 0  imageWidth
 y_index = map i from 0  rows+1 to 0  imageHeight)
 color = image.get(x_index, y_index)
 // red/green/blue will all be the same, as the image is grayscale
 heightFromColor = map red(color) from 0  255 to 0 – 1.0f 
 vertex_index = i * (columns + 1) + j
 vertices[vertex_index].y = heightFromColor
 }
}
  */
  void generateVertex() {
    float rowTemp = -gridSize / 2;
    for (int rows2 = 0; rows2 <= rows; rows2++) {
      float columnTemp = -gridSize / 2;
      for (int columns1 = 0; columns1 <= columns; columns1++) {
        vertex.add(new PVector(columnTemp, 0, rowTemp));
        columnTemp += gridSize / columns;
      }
      rowTemp += gridSize / rows;
    }
  }
  void generateTriangle() {
    int verticesrow = columns + 1;
    for (int rows2 = 0; rows2 < rows; rows2++) {
      for (int columns1 = 0; columns1 < columns; columns1++) {
        startIndex = rows2 * verticesrow + columns1;
        trianglesData.add(startIndex);
        trianglesData.add(startIndex + 1);
        trianglesData.add(startIndex + verticesrow);

        trianglesData.add(startIndex + 1);
        trianglesData.add(startIndex + verticesrow + 1);
        trianglesData.add(startIndex + verticesrow);
      }
    }
  }
  void generateHeight() {
    for (int rows2 = 0; rows2 <= rows; rows2++) {
      for (int columns1 = 0; columns1 <= columns; columns1++) {
        xIdx = map(columns1, 0, columns + 1, 0, heightmap.width);
        yIdx = map(rows2, 0, rows + 1, 0, heightmap.height);
        colour = heightmap.get(int(xIdx), int(yIdx));

        heightFromColor = map(red(colour), 0, 255, 0, 1.0f);

        vertIdx = rows2 * (columns + 1) + columns1;
        vertex.get(vertIdx).y = -heightFromColor;
      }
    }
  }
  void Render() {
    if (stroke2) {
      stroke(0);
    } else {
      noStroke();
    }

    fill(255, 255, 255);
    beginShape(TRIANGLES);
    for (int i = 0; i < trianglesData.size(); i++) {
      int vertIndex = trianglesData.get(i);
      vertexData = vertex.get(vertIndex);
/*
from the project pdf --------------------
If the height is between 1.0 and 0.8
It’s a white (snow) vertex – use the snow color
If the height is between 0.4 and 0.8
It’s a gray (rock) vertex – use the rock color
If the height is between 0.2 and 0.4
It’s a green (grass) vertex – use the grass color
Otherwise…
It’s a blue (water) vertex – use the water color
*/
      if (colour2) {
      
        //from the project pdf -----------------
        //relativeHeight = absolute value of vertex.y * heightModifier / -snowThreshold
      
        relativeHeight = abs(vertexData.y) * heightMod2 / snowThresh2;
        if (0.8 < relativeHeight) {
          if (blend2) {
            ratio = (relativeHeight - 0.8f) / 0.2f;
            // lerpColor(c1, c2, amt)
            fill(lerpColor(dwaneTheRock, johnSnow, ratio));
          } else {
            fill(johnSnow);
          }
        }
        if (0.4 < relativeHeight && relativeHeight < 0.8) {
          if (blend2) {
            ratio = (relativeHeight - 0.4f) / 0.4f;
            fill(lerpColor(grass, dwaneTheRock, ratio));
          } else {
            fill(dwaneTheRock);
          }
        } else if (relativeHeight < 0.2) {
          if (blend2) {
            ratio = relativeHeight / 0.2f;
            fill(lerpColor(water, dirt, ratio));
          } else {
            fill(water);
          }
        }
        if (0.2 < relativeHeight && relativeHeight < 0.4) {
          if (blend2) {
            ratio = (relativeHeight - 0.2f) / 0.2f;
            fill(lerpColor(dirt, grass, ratio));
          } else {
            fill(grass);
          }
        }
      }

      vertex(vertexData.x, vertexData.y * heightMod2, vertexData.z);
    }
    endShape();
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  cam.Zoom(e);
  // debuging
  println("Zoom event happened: " + event);
}
void keyReleased() {
  if (key == ENTER) {
    generate();
    // debuging
    println("Key pressed: " + key);
  }
}
void mouseDragged() {
  if (cp5.isMouseOver()) {
    return;
  } else {
    float deltaX = (mouseX - pmouseX) * 0.015f;
    float deltaY = (mouseY - pmouseY) * 0.015f;

    cam.phi += deltaX;
    if (degrees(cam.theta) - degrees(deltaY) > 180
        && degrees(cam.theta) - degrees(deltaY) < 269) {
      cam.theta -= deltaY;
    }
  }
}