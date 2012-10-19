int sW = 640;
int sH = 480;
//int sD = 
PVector camEye = new PVector(sW/2, sH/2, (sH/2)/tan((PI*30)/180));
PVector camPos = new PVector(sW/2, sH/2, 0);
float delta = 5;

void setup() {
  size(640, 480, P3D);
}

void draw() {
  background(0);
  pushMatrix();
  camera(camEye.x, camEye.y, camEye.z, camPos.x, camPos.y, camPos.z, 0, 1, 0);
  translate(320, 240, 0);
  rotateX(-PI/6);
  rotateY(PI/3);
  box(100);
  popMatrix();
  
  if (keyPressed) {
    if (key=='w') camEye.z -= delta;
    if (key=='a') camPos.x += delta;
    if (key=='s') camEye.z += delta;
    if (key=='d') camPos.x -= delta;
    if(keyCode==UP) camPos.y += delta;
    if(keyCode==DOWN) camPos.y -= delta;
    if(keyCode==LEFT) camEye.x += delta;
    if(keyCode==RIGHT) camEye.x -= delta;
  }
  
    if(mouseX>pmouseX) camEye.x -= delta * 2; 
    if(mouseX<pmouseX) camEye.x += delta * 2; 
    if(mouseY>pmouseY) camEye.y -= delta * 2; 
    if(mouseY<pmouseY) camEye.y += delta * 2; 
    
  println(camEye.x + " " + camEye.y + " " + camEye.z + " " + camPos.x + " " + camPos.y + " " + camPos.z);
}



