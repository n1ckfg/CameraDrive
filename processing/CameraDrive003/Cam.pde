// https://github.com/jrc03c/queasycam
// https://processing.org/reference/camMatera_.html

import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Robot;
import java.awt.GraphicsEnvironment;
//import java.util.HashMap;
//import processing.core.*;
//import processing.event.KeyEvent;

class Cam {
  
  boolean controllable;
  boolean enablePosition = true;
  boolean enableRotation = true;
  boolean enableMouse = true;
  float speed;
  float sensitivity;
  PVector pos;
  float pan;
  float tilt;
  PVector velocity;
  float friction;

  Robot robot;
  PVector poi;
  PVector up;
  PVector right;
  PVector forward;
  Point rotMouse;
  Point pRotMouse;
  PVector mouse;
  //HashMap<Character, Boolean> keys;

  PGraphics3D p3d;
  PMatrix3D proj, camMat, modvw, modvwInv, screen2Model;    
  String displayText = "";
  PFont font;
  int fontSize = 12;
  
  Cam() {
    try {
      robot = new Robot();
    } catch (Exception e){}

    controllable = true;
    speed = 3f;
    sensitivity = 2f;
    reset();
    friction = 0.75f;
    //keys = new HashMap<Character, Boolean>();

    //perspective(PI/3f, (float)width/(float)height, 0.01f, 1000f);
    
    font = createFont("Arial", fontSize);
    initMats(); 
  }
  
  void initMats() {
    p3d = (PGraphics3D) g;
    //proj = new PMatrix3D();
    camMat = new PMatrix3D();
    //modvw = new PMatrix3D();
    modvwInv = new PMatrix3D();
    screen2Model = new PMatrix3D();    
  }

  PVector screenToWorldCoords(PVector p) {
    //proj = p3d.projection.get();
    camMat = p3d.modelview.get();
    //modvw = p3d.modelview.get();
    modvwInv = p3d.modelviewInv.get();
    screen2Model = modvwInv;
    screen2Model.apply(camMat);
    float screen[] = { p.x, p.y, p.z };
    float model[] = { 0, 0, 0 };
    model = screen2Model.mult(screen, model);
    
    PVector returns = new PVector(model[0] + (poi.x - width/2), model[1] + (poi.y - height/2), model[2]);
    println(returns);
    return returns;
  }
  
  void screenToWorldMouse() {
    mouse = screenToWorldCoords(new PVector(mouseX, mouseY, poi.z));
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
  
  void getRotFromMouse() {
    rotMouse = MouseInfo.getPointerInfo().getLocation();
    if (pRotMouse == null) pRotMouse = new Point(rotMouse.x, rotMouse.y);
    
    int w = GraphicsEnvironment.getLocalGraphicsEnvironment().getMaximumWindowBounds().width;
    int h = GraphicsEnvironment.getLocalGraphicsEnvironment().getMaximumWindowBounds().height;
    
    if (rotMouse.x < 1 && (rotMouse.x - pRotMouse.x) < 0){
      robot.mouseMove(w-2, rotMouse.y);
      rotMouse.x = w-2;
      pRotMouse.x = w-2;
    }
        
    if (rotMouse.x > w-2 && (rotMouse.x - pRotMouse.x) > 0){
      robot.mouseMove(2, rotMouse.y);
      rotMouse.x = 2;
      pRotMouse.x = 2;
    }
    
    if (rotMouse.y < 1 && (rotMouse.y - pRotMouse.y) < 0){
      robot.mouseMove(rotMouse.x, h-2);
      rotMouse.y = h-2;
      pRotMouse.y = h-2;
    }
    
    if (rotMouse.y > h-1 && (rotMouse.y - pRotMouse.y) > 0){
      robot.mouseMove(rotMouse.x, 2);
      rotMouse.y = 2;
      pRotMouse.y = 2;
    }
  }
    
  void calcPanTilt() {
    pan += map((width-rotMouse.x) - (width-pRotMouse.x), 0, width, 0, TWO_PI) * sensitivity;
    tilt += map((height-rotMouse.y) - (height-pRotMouse.y), 0, height, 0, PI) * sensitivity;
    
    tilt = clamp(tilt, -PI/2.01f, PI/2.01f);  
    if (tilt == PI/2) tilt += 0.001f;
  }
  
  void calcDirections() {
    forward = new PVector(cos(pan), tan(tilt), sin(pan));
    forward.normalize();
    right = new PVector(cos(pan - PI/2), 0, sin(pan - PI/2));
    right.normalize();
    up = right.cross(forward);
    up.normalize();
  }
  
  void updateRotation() {
    if (enableRotation) {
      getRotFromMouse();
      calcPanTilt();
    }
    calcDirections();
    if (enableRotation) pRotMouse = new Point(rotMouse.x, rotMouse.y);
  }
  
  void updatePosition() {
    if (enablePosition) {
      velocity.mult(friction);
      pos.add(velocity);
    }
    poi = PVector.add(pos, forward);
  }
  
  void update() {
    if (!controllable) return;
    updateRotation();
    updatePosition();
    if (enableMouse) screenToWorldMouse();
  }
  
  void draw(){
    camera(pos.x, pos.y, pos.z, poi.x, poi.y, poi.z, up.x, up.y, up.z);
    drawText();
  }
  
  void run() {
    update();
    draw();
  }

  float clamp(float x, float min, float max){
    if (x > max) return max;
    if (x < min) return min;
    return x;
  }
  
  PVector getForward(){
    return forward;
  }
  
  PVector getUp(){
    return up;
  }
  
  PVector getRight(){
    return right;
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
  
  void defaultPos() {
    pos = new PVector(0,0,0);
    pos.x = width/2.0;
    pos.y = height/2.0;
    pos.z = (height/2.0) / tan(PI*30.0 / 180.0);
  }
  
  void defaultPoi() {
    poi = new PVector(0,0,0);
    poi.x = width/2.0;
    poi.y = height/2.0;
    poi.z = 0;
  }
  
  void reset() {
    defaultPos();
    defaultPoi();
    up = new PVector(0, 1, 0);
    right = new PVector(1, 0, 0);
    forward = new PVector(0, 0, 1);
    velocity = new PVector(0, 0, 0);
    pan = 0f;
    tilt = 0f;
  }
  
}