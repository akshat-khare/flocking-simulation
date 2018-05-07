PShape s;
import peasy.PeasyCam;
PeasyCam cam;
//int shuffletriangle = 1;
void setup() {
  cam = new PeasyCam(this, 400);
  size(1800, 900, P3D);
  //s = createShape();
  println(frameRate);
  
}

void draw() {
  background(0);
  //shape(s, 0, 0);
  float t = 50;
  stroke(200);
  //int para = ((frameCount/2)%11 -5);
  //if(para==5 && frameCount%2==1){
  //  shuffletriangle = shuffletriangle * (-1);
  //}
  //println(shuffletriangle);
  beginShape(TRIANGLES);
  
    //fill(150, 0, 0, 100);
    fill(150, 0, 0, 100);
    //body
    vertex(0, 0, -6*t);
    vertex(0, 3*t, -20*t);
    vertex(0, 0, 8*t);
    //pushMatrix();
     fill(150, 150, 0, 100);
    //rotateZ(PI/2);
    vertex(0, 0.5*t, -8*t);
    vertex(-12*t,((frameCount/2)%14 -7)*t, -2*t);
    vertex(0, 0, 4*t);
    //popMatrix();
    //pushMatrix();
     fill(150, 0, 150, 100);
    //rotateZ(-PI/2);
    vertex(0, 0, 4*t);
    vertex(12*t, ((frameCount/2)%14 -7)*t, -2*t);
    vertex(0, 0.5*t, -8*t);
    //popMatrix();
  endShape();
  //println(frameCount);
}
