int sW = 640;
int sH = 480;
//int sD = 
PVector camEye = new PVector(sW/2, sH/2, (sH/2)/tan((PI*30)/180));
PVector camPos = new PVector(sW/2, sH/2, 0);
float delta = 5;
PVector p = new PVector(sW/2,sH/2,0);

void setup() {
  size(640, 480, P3D);
}

void draw() {
  background(0);
  pushMatrix();
  camEye.x = tween(camEye.x,100,100);
  camEye.y = tween(camEye.y,100,100);
  camEye.z = tween(camEye.z,100,100);
  camPos.x = tween(camEye.x,320,100);
  camPos.y = tween(camEye.y,240,100);
  camPos.z = tween(camEye.z,-100,100);
  camera(camEye.x, camEye.y, camEye.z, camPos.x, camPos.y, camPos.z, 0, 1, 0);
  translate(320, 240, 0);
  rotateX(-PI/6);
  rotateY(PI/3);
  fill(255,0,0);
  stroke(255,100,0);
  box(100);
  popMatrix();
  println(camEye.x + " " + camEye.y + " " + camEye.z + " " + camPos.x + " " + camPos.y + " " + camPos.z);
}

float tween(float v1, float v2, float e) {
  v1 += (v2-v1)/e;
  return v1;
}

