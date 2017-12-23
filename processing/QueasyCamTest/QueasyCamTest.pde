Cam cam;

void setup(){
  size(400, 400, P3D);
  cam = new Cam();
}

void draw(){
  background(0);
  box(200);
  updateControls();
  cam.run();
}