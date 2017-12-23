// https://processing.org/reference/camMatera_.html
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Robot;
import java.awt.GraphicsEnvironment;

class Cam {

  PVector pos = new PVector(0,0,0);
  PVector poi = new PVector(0,0,0);
  PVector up = new PVector(0,0,0);

  PVector right = new PVector(1, 0, 0);
  PVector forward = new PVector(0, 0, 1);
  PVector velocity = new PVector(0, 0, 0);
  float pan = 0;
  float tilt = 0;
  float sensitivity = 1;
  float speed = 3;
  float friction = 0.75;

  PVector mouse = new PVector(0,0,0);
  
  PGraphics3D p3d;
  PMatrix3D proj, camMat, modvw, modvwInv, screen2Model;
  Robot robot;
    
  String displayText = "";
  PFont font;
  int fontSize = 12;

  void init() {
    try {
      robot = new Robot();
    } catch (Exception e) { }
    p3d = (PGraphics3D) g;
    //proj = new PMatrix3D();
    camMat = new PMatrix3D();
    //modvw = new PMatrix3D();
    modvwInv = new PMatrix3D();
    screen2Model = new PMatrix3D();
    
    font = createFont("Arial", fontSize);
  }
  
  PVector screenToWorldCoords(PVector p) {
    //proj = p3d.projection.get();
    camMat = p3d.modelview.get(); //camMatera.get();
    //modvw = p3d.modelview.get();
    modvwInv = p3d.modelviewInv.get();
    screen2Model = modvwInv;
    screen2Model.apply(camMat);
    float screen[] = { p.x, p.y, p.z };
    float model[] = { 0, 0, 0 };
    model = screen2Model.mult(screen, model);
    
    PVector returns = new PVector(model[0] + (poi.x - width/2), model[1] + (poi.y - height/2), model[2]);
    //println(returns);
    return returns;
  }
  
  void screenToWorldMouse() {
    mouse = screenToWorldCoords(new PVector(mouseX, mouseY, poi.z));
  }
  
  Cam() {
    resetPos();
    calcPoi();
    calcUp();
    init();
  }
  
  Cam(PVector _pos) {
    pos = _pos;
    calcPoi();
    calcUp();
    init();
  }
  
  Cam(PVector _pos, PVector _poi) {
    pos = _pos;
    poi = _poi;
    calcUp();
    init();
  }
  
  Cam(PVector _pos, PVector _poi, PVector _up) {
    pos = _pos;
    poi = _poi;
    up = _up;
    init();
  }
  
  void update() {
    updateRotation();
    updatePosition();
    screenToWorldMouse();
  }
  
  void draw() {
    camera(pos.x, pos.y, pos.z, poi.x, poi.y, poi.z, up.x, up.y, up.z);
    drawText();
  }
  
  void run() {
    update();
    draw();
  }
  
  void moveForward() {
    velocity.add(PVector.mult(forward, speed));
  }
  
  void moveBack() {
    velocity.sub(PVector.mult(forward, speed));
  }
  
  void moveLeft() {
    velocity.sub(PVector.mult(right, speed));
  }
  
  void moveRight() {
    velocity.add(PVector.mult(right, speed));
  }
  
  void moveUp() {
    velocity.sub(PVector.mult(up, speed));
  }
  
  void moveDown() {
    velocity.add(PVector.mult(up, speed));
  }
  
  void updatePosition() {
    velocity.mult(friction);
    pos.add(velocity);
    poi = PVector.add(pos, forward);
  }
  
  void updateRotation() {
    getRotFromMouse();
    
    calcPanTilt();

    calcDirections();
  }
  
  void getRotFromMouse() {
    if (mouseX < 1 && (mouseY - pmouseX) < 0){
      robot.mouseMove(width-2, mouseY);
      mouseX = width-2;
      pmouseX = width-2;
    }
        
    if (mouseX > width-2 && (mouseX - pmouseX) > 0){
      robot.mouseMove(2, mouseY);
      mouseX = 2;
      pmouseX = 2;
    }
    
    if (mouseY < 1 && (mouseY - pmouseY) < 0){
      robot.mouseMove(mouseX, height-2);
      mouseY = height-2;
      pmouseY = height-2;
    }
    
    if (mouseY > height-1 && (mouseY - pmouseY) > 0){
      robot.mouseMove(mouseX, 2);
      mouseY = 2;
      pmouseY = 2;
    }
  }
  
  void calcPanTilt() {
    //pan += map(rotMouse.x - pRotMouse.x, 0, width, 0, TWO_PI) * sensitivity;
    //tilt += map(rotMouse.y - pRotMouse.y, 0, height, 0, PI) * sensitivity;
    pan += map((width-mouseX) - (width-pmouseX), 0, width, 0, TWO_PI) * sensitivity;
    tilt += map((height-mouseY) - (height-pmouseY), 0, height, 0, PI) * sensitivity;
    tilt = constrain(tilt, -PI/2.01, PI/2.01);
    if (tilt == PI/2) tilt += 0.001;
  }
  
  void calcDirections() {    
    calcForward();
    calcRight(); 
    calcUp();
  }
  
  void resetPos() {
    pos.x = width/2.0;
    pos.y = height/2.0;
    pos.z = (height/2.0) / tan(PI*30.0 / 180.0);
  }
  
  void resetPoi() {
    poi.x = width/2.0;
    poi.y = height/2.0;
    poi.z = 0;
  }
  
  void resetUp() {
    up.x = 0;
    up.y = 1;
    up.z = 0;
  }
  
  void calcPoi() {
    PVector.add(pos, forward);
  }
  
  void calcForward() {
    forward = new PVector(cos(pan), tan(tilt), sin(pan));
    forward.normalize();
  }
  
  void calcRight() {
    right = new PVector(cos(pan - PI/2), 0, sin(pan - PI/2));
    right.normalize();
  }
  
  void calcUp() {
    up = right.cross(forward);
    up.normalize();
  }
  
  void reset() {
    resetPos();
    calcPoi();
    calcUp();
  }
  
  void drawText() {
    if (!displayText.equals("")) {
      pushMatrix();  
      translate((pos.x - (width/2)) + (fontSize/2), (pos.y - (height/2)) + fontSize, poi.z);
      textFont(font, fontSize);
      text(displayText, 0, 0);
      popMatrix();
    }
  }
  
}

// TODO
// https://processing.org/reference/frustum_.html
// https://processing.org/reference/beginCamera_.html
// https://processing.org/reference/endCamera_.html