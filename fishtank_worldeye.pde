PShape obj;

float rotX = 3.14;
float rotY = 0;
float radius;
float cameraZ;

PMatrix3D projection, modelview, modelviewInv, camera, cameraInv, projmodelview;

void setup() {
  size(640, 480, P3D);
  //fullScreen(P3D,2);

  // The file "bot.obj" must be in the data folder
  // of the current sketch to load successfully
  obj = loadShape("teapot.obj");

  //select the preccise value as each parameters 
  float scale_factor = 20;
  obj.scale(scale_factor, scale_factor, scale_factor);
  //radius = (height/2)*sqrt(3)/2;
  radius = height/2;
  println(radius);
  println(width);
  println(height);

  noFill();
  stroke(88, 204, 145);

  // プロジェクション行列
  projection = ((PGraphicsOpenGL)g).projection;

  // モデルビュー行列
  modelview = ((PGraphicsOpenGL)g).modelview;

  // モデルビュー行列の逆行列
  modelviewInv = ((PGraphicsOpenGL)g).modelviewInv;

  // ビュー行列
  camera = ((PGraphicsOpenGL)g).camera;

  // ビュー行列の逆行列
  cameraInv = ((PGraphicsOpenGL)g).cameraInv;

  // プロジェクション行列とモデルビュー行列を乗算した行列
  projmodelview = ((PGraphicsOpenGL)g).projmodelview;

  //camera.print();
  //cameraInv.print();
  cameraZ = height;
  camera.m23 = -cameraZ;
  PMatrix3D camera_copy = camera.get();
  PMatrix3D cameraInv_copy = camera.get();
  cameraInv_copy.invert();
  cameraInv = cameraInv_copy;
  camera.print();
  cameraInv.print();
}

void draw() {
  background(0, 0, 0);
  lights();

  pushMatrix();
  translate(width/2, height/2, 0);

  /*
  //draw the sphere
  pushMatrix();
  rotateX(frameCount*0.005);
  rotateY(frameCount*0.005);
  rotateZ(frameCount*0.005);

  for (int s = 0; s <= 180; s += 10) {
    float radianS = radians(s);
    float z = radius * cos(radianS);
    for (int t = 0; t < 360; t += 10) {
      float radianT = radians(t);
      // sin(radianS)は0→1→0の順で変化するので
      // radius * sin(radianS)は0→200→0になる
      float x = radius * sin(radianS) * cos(radianT);
      float y = radius * sin(radianS) * sin(radianT);
      stroke(0, 128, 128);
      strokeWeight(8);
      point(x, y, z);
    }
  }
  popMatrix();
  */
  
  //int ftr = 4;
  //rect(-width/ftr,-height/ftr,width*2/ftr,height*2/ftr);
  //ellipse(0,0,400,400);
  translate(0, height/20, 0);
  // オブジェクトの回転(引数はラジアン)
  rotateX(rotX);
  rotateY(rotY);
  // モデルの描画
  shape(obj);
  popMatrix();

  //rotY = rotY + 0.01;

  if (rotY >= 6.28) rotY = 0;
  
  float cameraX = width/2.00;
  float cameraY = height/2.00;
  float cameraZ = height*1.00;
  float distance = sqrt(sq((cameraX-width/2))+sq(cameraY-height/2)+sq(cameraZ));
  float fov = 2 * atan(height/(2*distance));
  float aspect = float(width)/float(height);
  float phi = asin((height/2-cameraY)/distance);
  float theta;
  if(cameraZ>0){
    theta = atan((cameraX-width/2)/cameraZ);
  }else if(cameraZ<0){
    theta = atan((cameraX-width/2)/cameraZ) + PI;
  }else{
    if(cameraX-width/2>0){
      theta = PI/2;
    }else{
      theta = -PI/2;
    }
  }
  /*
  camera.m03 = -cameraX;
  camera.m13 = -cameraY;
  camera.m23 = -cameraZ;
  PMatrix3D camera_copy = camera.get();
  PMatrix3D cameraInv_copy = camera.get();
  cameraInv_copy.invert();
  cameraInv = cameraInv_copy;
  */
  camera(cameraX,cameraY,cameraZ,width/2,height/2,0,0.1,0.1,0.1);
  perspective(fov, aspect, cameraZ/10.0, cameraZ*10.0);
}