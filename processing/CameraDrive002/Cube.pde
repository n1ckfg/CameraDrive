class Cube {
  
  PVector pos;
  PVector rot;
  float birthTime = 0;
  float lifeTime = 10;
  boolean alive = true;
  
  Cube() {
    pos = cam.mouse;
    rot = new PVector(-PI/random(3,6), PI/random(3,6), 0);
    birthTime = millis();
    lifeTime *= 1000;
  }
  
  void update() {
    if (millis() > birthTime + lifeTime) alive = false;
  }
  
  void draw() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateXYZ(rot.x, rot.y, rot.z);
    box(10);
    popMatrix();
  }
  
  void run() {
    if (alive) {
      update();
      draw();
    }
  }
  
  void rotateXYZ(float x, float y, float z){
    rotateX(x);
    rotateY(y);
    rotateZ(z);
  }
  
}