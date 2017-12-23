// https://github.com/jrc03c/queasycam
// https://processing.org/reference/camMatera_.html

import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Robot;
import java.awt.GraphicsEnvironment;
import java.util.HashMap;
import processing.core.*;
import processing.event.KeyEvent;

class Cam {
  
  boolean controllable;
  float speed;
  float sensitivity;
  PVector position;
  float pan;
  float tilt;
  PVector velocity;
  float friction;

  Robot robot;
  PVector center;
  PVector up;
  PVector right;
  PVector forward;
  Point mouse;
  Point prevMouse;
  HashMap<Character, Boolean> keys;

  Cam() {
    try {
      robot = new Robot();
    } catch (Exception e){}

    controllable = true;
    speed = 3f;
    sensitivity = 2f;
    position = new PVector(0f, 0f, 0f);
    up = new PVector(0f, 1f, 0f);
    right = new PVector(1f, 0f, 0f);
    forward = new PVector(0f, 0f, 1f);
    velocity = new PVector(0f, 0f, 0f);
    pan = 0f;
    tilt = 0f;
    friction = 0.75f;
    keys = new HashMap<Character, Boolean>();

    perspective(PI/3f, (float)width/(float)height, 0.01f, 1000f);
  }

  void getRotFromMouse() {
    mouse = MouseInfo.getPointerInfo().getLocation();
    if (prevMouse == null) prevMouse = new Point(mouse.x, mouse.y);
    
    int w = GraphicsEnvironment.getLocalGraphicsEnvironment().getMaximumWindowBounds().width;
    int h = GraphicsEnvironment.getLocalGraphicsEnvironment().getMaximumWindowBounds().height;
    
    if (mouse.x < 1 && (mouse.x - prevMouse.x) < 0){
      robot.mouseMove(w-2, mouse.y);
      mouse.x = w-2;
      prevMouse.x = w-2;
    }
        
    if (mouse.x > w-2 && (mouse.x - prevMouse.x) > 0){
      robot.mouseMove(2, mouse.y);
      mouse.x = 2;
      prevMouse.x = 2;
    }
    
    if (mouse.y < 1 && (mouse.y - prevMouse.y) < 0){
      robot.mouseMove(mouse.x, h-2);
      mouse.y = h-2;
      prevMouse.y = h-2;
    }
    
    if (mouse.y > h-1 && (mouse.y - prevMouse.y) > 0){
      robot.mouseMove(mouse.x, 2);
      mouse.y = 2;
      prevMouse.y = 2;
    }
  }
  
  void calcPanTilt() {
    pan += map(mouse.x - prevMouse.x, 0, width, 0, TWO_PI) * sensitivity;
    tilt += map(mouse.y - prevMouse.y, 0, height, 0, PI) * sensitivity;
    tilt = clamp(tilt, -PI/2.01f, PI/2.01f);  
    if (tilt == PI/2) tilt += 0.001f;
  }
  
  void calcDirections() {
    forward = new PVector(cos(pan), tan(tilt), sin(pan));
    forward.normalize();
    right = new PVector(cos(pan - PI/2), 0, sin(pan - PI/2));
  }
  
  void updateRotation() {
    getRotFromMouse();
    calcPanTilt();
    calcDirections();
    prevMouse = new Point(mouse.x, mouse.y);
  }
  
  void updatePosition() {
    velocity.mult(friction);
    position.add(velocity);
    center = PVector.add(position, forward);
  }
  
  void update() {
    if (!controllable) return;
    updateRotation();
    updatePosition();
  }
  
  void draw(){
    /*
    if (keys.containsKey('a') && keys.get('a')) velocity.add(PVector.mult(right, speed));
    if (keys.containsKey('d') && keys.get('d')) velocity.sub(PVector.mult(right, speed));
    if (keys.containsKey('w') && keys.get('w')) velocity.add(PVector.mult(forward, speed));
    if (keys.containsKey('s') && keys.get('s')) velocity.sub(PVector.mult(forward, speed));
    if (keys.containsKey('q') && keys.get('q')) velocity.add(PVector.mult(up, speed));
    if (keys.containsKey('e') && keys.get('e')) velocity.sub(PVector.mult(up, speed));
    */
    camera(position.x, position.y, position.z, center.x, center.y, center.z, up.x, up.y, up.z);
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
    velocity.add(PVector.mult(right, speed));
  }
  
  void moveRight() {
    velocity.sub(PVector.mult(right, speed));
  }
  
  void moveUp() {
    velocity.sub(PVector.mult(up, speed));
  }
  
  void moveDown() {
    velocity.add(PVector.mult(up, speed));
  }
  
}