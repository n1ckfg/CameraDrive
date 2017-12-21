// https://processing.org/reference/camera_.html
import java.awt.Robot;

class Cam {

  PVector pos = new PVector(0,0,0);
  PVector poi = new PVector(0,0,0);
  PVector up = new PVector(0,0,0);

  PVector right = new PVector(1, 0, 0);
  PVector forward = new PVector(0, 0, 1);
  PVector velocity = new PVector(0, 0, 0);
  float pan = 0;
  float tilt = 0;
  float sensitivity = 2;

  PVector mouse = new PVector(0,0,0);
  
  PGraphics3D p3d;
  PMatrix3D proj, cam, modvw, modvwInv, screen2Model;
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
    cam = new PMatrix3D();
    //modvw = new PMatrix3D();
    modvwInv = new PMatrix3D();
    screen2Model = new PMatrix3D();
    
    font = createFont("Arial", fontSize);
  }
  
  PVector screenToWorldCoords(PVector p) {
    //proj = p3d.projection.get();
    cam = p3d.modelview.get(); //camera.get();
    //modvw = p3d.modelview.get();
    modvwInv = p3d.modelviewInv.get();
    screen2Model = modvwInv;
    screen2Model.apply(cam);
    float screen[] = { p.x, p.y, p.z };
    float model[] = { 0, 0, 0 };
    model = screen2Model.mult(screen, model);
    
    return new PVector(model[0] + (poi.x - width/2), model[1] + (poi.y - height/2), model[2]);
  }
  
  void screenToWorldMouse() {
    mouse = screenToWorldCoords(new PVector(mouseX, mouseY, poi.z));
  }
  
  Cam() {
    defaultPos();
    defaultPoi();
    defaultUp();
    init();
  }
  
  Cam(PVector _pos) {
    pos = _pos;
    defaultPoi();
    defaultUp();
    init();
  }
  
  Cam(PVector _pos, PVector _poi) {
    pos = _pos;
    poi = _poi;
    defaultUp();
    init();
  }
  
  Cam(PVector _pos, PVector _poi, PVector _up) {
    pos = _pos;
    poi = _poi;
    up = _up;
    init();
  }
  
  void update() {
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
  
  void move(PVector p) {
    pos = pos.add(p);
    poi = poi.add(p);
  }
  
  void rotation() {        
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
    
    pan += map(mouseX - pmouseX, 0, width, 0, TWO_PI) * sensitivity;
    tilt += map(mouseY - pmouseY, 0, height, 0, PI) * sensitivity;
    tilt = constrain(tilt, -PI/2.01, PI/2.01);
    
    if (tilt == PI/2) tilt += 0.001;

    forward = new PVector(cos(pan), tan(tilt), sin(pan));
    forward.normalize();
    right = new PVector(cos(pan - PI/2), 0, sin(pan - PI/2));    
  }
  
  void defaultPos() {
    pos.x = width/2.0;
    pos.y = height/2.0;
    pos.z = (height/2.0) / tan(PI*30.0 / 180.0);
  }
  
  void defaultPoi() {
    poi.x = width/2.0;
    poi.y = height/2.0;
    poi.z = 0;
  }
  
  void defaultUp() {
    up.x = 0;
    up.y = 1;
    up.z = 0;
  }
  
  void reset() {
    defaultPos();
    defaultPoi();
    defaultUp();
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