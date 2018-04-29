import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Boids extends PApplet {

int customframerate=60;
Boid barry;
ArrayList<Boid> boids;
ArrayList<Avoid> avoids;
Boundary box;
PImage bg;
volatile PImage tempbg;
float imgfac = 0;

float globalScale = 1.13f;
float eraseRadius = 20;
int rotate = 1;
String tool = "boids";
String environment = "sphere";


// boid control
float maxSpeed;
float friendRadius;
float crowdRadius;
float avoidRadius;
float avoidWallRadius;
float coheseRadius;

int boundary;

boolean option_friend = true;
boolean option_crowd = true;
boolean option_avoid = true;
boolean option_noise = true;
boolean option_cohese = true;

// gui crap
int messageTimer = 0;
String messageText = "";

public void settings  () {
  size(1800, 1000, P3D);
}

public void setup () {
  frameRate(customframerate);
  bg = loadImage("data/pansky.jpg");
  imgfac = (bg.width * height )/bg.height;
  //bg.get(0,0,500,200);
  bg.resize((int) imgfac,height);
  tempbg = bg.get(0,0,width, height);
  println("width and height are " + width + " " +height + " finimage width and height are " + bg.width + " " + bg.height);
  textSize(16);
  textAlign(CENTER,BOTTOM);
  recalculateConstants();
  boids = new ArrayList<Boid>();
  avoids = new ArrayList<Avoid>();
  setupWalls();
  println(boundary + " is boundary");
  int id = 0;
  for (int i = 0; i < 200; i+= 1) {
      id = id + 1;
      // println("New Boid added with id:" +id);
      boids.add(new Boid(random(-100,100), random(-100,100), random(-100,100), id));
  }
  //boids.add(new Boid(boundary/4, 0, 0, 0));
  //boids.add(new Boid(boundary/4 - 20, 0, 0, 1));
  
}

// haha
public void recalculateConstants () {
  //stroke(150);
  //text(globalScale, boundary/2, boundary/2 );
  maxSpeed = 1.5f * globalScale;
  friendRadius = 40 * globalScale;
  crowdRadius = (friendRadius / 2);
  avoidRadius = 20 * globalScale;
  avoidWallRadius = 80 * globalScale;
  coheseRadius = 1.5f * friendRadius;
  //println("maxspeed is " +maxSpeed);
  //println("friendradius is " +friendRadius);
  //println("crowdRadius is " +crowdRadius);
  //println("avoidRadius is " +avoidRadius);
  //println("coheseradius is " +coheseRadius);
  //println("width is " +width);
  //println("height is " +height);
}


public void setupWalls() {
  boundary = (int)(350 * globalScale);
  box = new Boundary(boundary);
}

public void setupCircle() {
  avoids = new ArrayList<Avoid>();
  for (int x = 0; x < 50; x+= 1) {
    float dir = (x / 50.0f) * TWO_PI;
    avoids.add(new Avoid(width * 0.5f + cos(dir) * height*.4f, height * 0.5f + sin(dir)*height*.4f, 0));
  }
}

public void draw () {
  fill(0);
  text("mouse at : (" + mouseX + "," + mouseY +")" ,mouseX, mouseY-25);
  
  //background(0);
  noFill();
  stroke(255);
  strokeWeight(1);  
  box.drawsur();

  noStroke();
  colorMode(HSB);
  //fill(0, 100);
  //rect(0, 0, width, height);
  //println(tool);
  //if (tool == "erase") {
  //  noFill();
  //  stroke(0, 100, 260);
  //  rect(mouseX - eraseRadius, mouseY - eraseRadius, eraseRadius * 2, eraseRadius *2);
  //  if (mousePressed) {
  //    erase();
  //  }
  //} 
  for (int i = 0; i <boids.size(); i++) {
    Boid current = boids.get(i);
    // println("Boid id: " + i + " " + current.id + " is at "+ current.pos.x +" "+current.pos.y + " " + current.pos.z + " velocity is " + current.move.x + " " + current.move.y + " " + current.move.z );
    current.go();
    current.drawit();
  }

  //println(avoids.size());
  for (int i = 0; i <avoids.size(); i++) {
    Avoid current = avoids.get(i);
    current.go();
    current.drawthi();
  }

  if (messageTimer > 0) {
    messageTimer -= 1;
  }
  drawGUI();
}

public void keyPressed () {
  if (key == 'q') {
    tool = "boids";
    message("Add boids");
  } else if (key == 'w') {
    tool = "avoids";
    message("Place obstacles");
  } else if (key == '-') {
    message("Decreased scale");
    globalScale *= 0.8f;  
  } else if (key == '=') {
    message("Increased Scale");
    globalScale /= 0.8f;
  } else if (key == '1') {
    option_friend = option_friend ? false : true;
    message("Turned friend allignment " + on(option_friend));
  } else if (key == '2') {
    option_crowd = option_crowd ? false : true;
    message("Turned crowding avoidance " + on(option_crowd));
  } else if (key == '3') {
    option_avoid = option_avoid ? false : true;
    message("Turned obstacle avoidance " + on(option_avoid));
  } else if (key == '4') {
    option_cohese = option_cohese ? false : true;
    message("Turned cohesion " + on(option_cohese));
  } else if (key == '5') {
    option_noise = option_noise ? false : true;
    message("Turned noise " + on(option_noise));
  } else if (key == ',') {
    environment = "box";
  } else if (key == '.') {
    environment = "sphere";
  } else if (key == 'r') {
    rotate = (rotate+1)%2;
  } else if (key == 'p') {
    noLoop();
  } else if (key == 's') {
    redraw();
  } else if (key == 'c') {
    //println("key was pressed");
    loop();
  }
  //println("calling recalculate");
  recalculateConstants();
  //println("recalculate called");
}

public void drawGUI() {
  if (messageTimer > 0) {
    fill((min(30, messageTimer) / 30.0f) * 255.0f);

    text(messageText, 10, height - 20);
  }
}

public String s(int count) {
  return (count != 1) ? "s" : "";
}

public String on(boolean in) {
  return in ? "on" : "off";
}

public void mousePressed () {
  switch (tool) {
  case "boids":
    boids.add(new Boid(mouseX-(width/2), mouseY-(height/2), 0, boids.size()+1));
    message(boids.size() + " Total Boid" + s(boids.size()));
    break;
  case "avoids":
    float xcoor = mouseX-(width/2);
    float ycoor = mouseY-(height/2);
    if (xcoor > (boundary/2) || xcoor < (-boundary/2)) {
      xcoor = abs(xcoor) % boundary;
    }
    if (ycoor > (boundary/2) || ycoor < (-boundary/2)) {
      ycoor = abs(ycoor) % boundary;
    }
    avoids.add(new Avoid(xcoor, ycoor, random(-100,100)));
    break;
  }
}

//void erase () {
//  for (int i = boids.size()-1; i > -1; i--) {
//    Boid b = boids.get(i);
//    if (abs(b.pos.x - mouseX) < eraseRadius && abs(b.pos.y - mouseY) < eraseRadius) {
//      boids.remove(i);
//    }
//  }

//  for (int i = avoids.size()-1; i > -1; i--) {
//    Avoid b = avoids.get(i);
//    if (abs(b.pos.x - mouseX) < eraseRadius && abs(b.pos.y - mouseY) < eraseRadius) {
//      avoids.remove(i);
//    }
//  }
//}

public void drawText (String s, float x, float y) {
  fill(0);
  text(s, x, y);
  fill(200);
  text(s, x-1, y-1);
}


public void message (String in) {
  messageText = in;
  messageTimer = (int) frameRate * 3;
}
class Avoid {
  PVector pos;
   
    Avoid (float xx, float yy, float zz) {
      pos = new PVector(xx,yy,zz);
    }
   
   public void go () {
     
   }
   
   //void setup () {
   // stroke(255);
   // strokeWeight(1);
   // frameRate(customframerate);
   //}
   
   public void drawthi () {
     pushMatrix();
     fill(0, 255, 200);
     translate(pos.x, pos.y, pos.z);
     box(10);  
     popMatrix();
   }
}
class Boundary {
    int boundary;
    int boundcount =0;
    float begwid =0;
    //volatile PImage tryme = bg.get(0,0,width, height);
    int thiwid = 0;
   
    Boundary (int b) {
      boundary = b;
    }
    
   //void setup() {
   // //noFill();
   // //stroke(150);
   // //strokeWeight(1);
   // //frameRate(customframerate);
   //}
   public void changeBackground(){
     tempbg = bg.get(thiwid,0,width, height);
   }
   public void drawsur () {
     
     boundcount++;
     //float begwid = (frameCount%(1256))/1256;
     if((begwid/1256) * width + width >bg.width || begwid >=1256){
       println("exceeded " + begwid);
       begwid = 0;
     }
     thiwid = (int) (begwid*width)/1256;
     //tryme = bg.get(thiwid,0,width, height);
     //println("size of to be rendered image is " + tryme.width +" "+ tryme.height + " width is " + width);
     //tryme.resize(width,height);
     if(frameCount%10==1){
       tempbg = bg.get(thiwid,0,width, height);
       begwid++;
       //background(tryme);
     }
     //thread("changeBackground");
     background(tempbg);
     //begwid++;
     
     //background(bg.get(thiwid,0,width, height));
     //background(0);
     //image(bg,-thiwid,0,-thiwid+width, height);
     
      //background(0);
      translate(width/2, height/2, 200);
      if (rotate == 1)
        rotateY(frameCount / 200.0f); 
  
      if(environment == "box"){
        box(boundary);
      }else if(environment == "sphere"){
        //boundary = boundary;
        sphereDetail(20,15);
        sphere((boundary * 0.866f));
      } 
      //noLoop();
   }
}
class Boid {
  // main fields
  PVector pos;
  PVector move;
  float shade;
  int id;
  ArrayList<Boid> friends;

  // timers
  int thinkTimer = 0;

  Boid (float xx, float yy, float zz, int ii) {
    pos = new PVector(0, 0, 0);
    pos.x = xx;
    pos.y = yy;
    pos.z = zz;
    id = ii;
    float angle = random(TWO_PI);
    move = new PVector(cos(angle), sin(angle), cos(angle));
    thinkTimer = PApplet.parseInt(random(10));
    shade = random(255);
    friends = new ArrayList<Boid>();
  }

  public void go () {
    increment();
    //wrap(); //to be included
    if (thinkTimer == 0 ) {
      // update our friend array (lots of square roots)
      getFriends();
    }
    flock();
    // println (move);
    pos.add(move);
  }

  public void flock () {
    PVector align = getAlignment();
    PVector separate = getSeparation(); 
    PVector avoidObjects =new PVector(0,0,0);
    if(environment == "box"){
       avoidObjects = getAvoidWallsBox();
    }else if(environment == "sphere"){
       avoidObjects = getAvoidWallsSphere();
    }
    
    PVector noise = new PVector(random(2) - 1, random(2) - 1, random(2) - 1);
    PVector cohese = getCohesion();

    align.mult(1.0f);
    if (!option_friend) align.mult(0);
    
    separate.mult(10.0f);
    if (!option_crowd) separate.mult(0);
    
    avoidObjects.mult(1.0f);
    if (!option_avoid) avoidObjects.mult(0);

    noise.mult(0);
    if (!option_noise) noise.mult(0);

    cohese.mult(0.002f);
    if (!option_cohese) cohese.mult(0);
    
    stroke(0, 255, 160);

    move.add(align);
    move.add(separate);
    move.add(avoidObjects);
    move.add(noise);
    move.add(cohese);

    move.limit(maxSpeed);
    
    shade += getAverageColor() * 0.03f;
    shade += (random(2) - 1) ;
    shade = (shade + 255) % 255; //max(0, min(255, shade));
  }

  public void getFriends () {
    ArrayList<Boid> nearby = new ArrayList<Boid>();
    for (int i =0; i < boids.size(); i++) {
      Boid test = boids.get(i);
      if (test == this) continue;
      if (abs(test.pos.x - this.pos.x) < friendRadius &&
        abs(test.pos.y - this.pos.y) < friendRadius &&
        abs(test.pos.z - this.pos.z) < friendRadius ) {
        nearby.add(test);
      }
    }
    friends = nearby;
  }

  public float getAverageColor () {
    float total = 0;
    float count = 0;
    for (Boid other : friends) {
      if (other.shade - shade < -128) {
        total += other.shade + 255 - shade;
      } else if (other.shade - shade > 128) {
        total += other.shade - 255 - shade;
      } else {
        total += other.shade - shade; 
      }
      count++;
    }
    if (count == 0) return 0;
    return total / (float) count;
  }

  public PVector getAlignment () {
    PVector sum = new PVector(0, 0, 0);
    int count = 0;

    for (Boid other : friends) {
      float d = PVector.dist(pos, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < friendRadius)) {
        PVector copy = other.move.copy();
        copy.normalize();
        copy.div(d); 
        sum.add(copy);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
    }
    return sum;
  }

  public PVector getSeparation() {
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Boid other : friends) {
      float d = PVector.dist(pos, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < crowdRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    return steer;
  }

  public PVector getAvoidAvoids() {
    PVector steer = new PVector(0, 0, 0);
    //int count = 0;

    for (Avoid other : avoids) {
      float d = PVector.dist(pos, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < avoidRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        //count++;            // Keep track of how many
      }
    }
    
    return steer;
  }
  
  public float getDistance (PVector p, float plane[]) {
    float distance = abs(p.x*plane[0] + p.y*plane[1] + p.z*plane[2] + plane[3])/sqrt(plane[0]*plane[0] + plane[1]*plane[1] + plane[2]*plane[2]);
    return distance;
  }
  
  // Avoid Walls (to be improved)
  public PVector getAvoidWallsBox () {
    //float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every wall in the system, check if it's too close
    float planes[][] = {{-1,0,0,boundary/2},{1,0,0,boundary/2},{0,-1,0,boundary/2},{0,1,0,boundary/2},{0,0,-1,boundary/2},{0,0,1,boundary/2}};
    for (int i = 0; i < 6; i++) {
      boolean isout = false;
      float plane[] = new float[4];
      for (int j = 0; j < 4; j++) {
        plane[j] = planes[i][j];
      }
      float d = getDistance(pos, plane);
      if ((d > 0) && (d < avoidWallRadius)) {
        // Calculate vector pointing away from the plane
        PVector targetPoint;
        if(plane[0]==1 || plane[0]==-1){
          if(abs(pos.x) > boundary/2){
            isout = true;
          }
          targetPoint = new PVector(-plane[0]*(boundary/2), pos.y, pos.z);
        }
        else if(plane[1]==1 || plane[1]==-1){
          if(abs(pos.y) > boundary/2){
            isout = true;
          }
          targetPoint = new PVector(pos.x, -plane[1]*(boundary/2), pos.z);
        }   
        else{
          if(abs(pos.z) > boundary/2){
            isout = true;
          }
          targetPoint = new PVector(pos.x, pos.y, -plane[2]*(boundary/2));
        }
        PVector diff;
        if(isout){
          diff = PVector.sub(targetPoint, pos);
        }else{
          diff = PVector.sub(pos, targetPoint);
        }
        diff.normalize();
        if(isout){
          diff.mult(100 * pos.mag());
        }else{
          diff.div(d);
        }
        //diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
      //return steer;
    }

    // As long as the vector is greater than 0
    //if (steer.mag() > 0) {
    //  // First two lines of code below could be condensed with new PVector setMag() method
    //  // Not using this method until Processing.js catches up
    //  // steer.setMag(maxspeed);

    //  // Implement Reynolds: Steering = Desired - Velocity
    //  steer.normalize();
    //  steer.mult(maxSpeed);
    //  steer.sub(move);
    //  steer.limit(maxSpeed);
    //}
    return steer;
  }
  
    public PVector getAvoidWallsSphere () {
    //float desiredseparation = 25.0f;
    PVector steer = pos.copy();
    float dist = pos.mag();
    float radius = boundary * 0.866f;
    steer.normalize();
    steer.mult(-1);
    if(dist>radius){
      steer.mult(dist);
    }else{
      steer.div(radius - dist);
    }
    
    return steer;
    
  }
  
  
  
  public PVector getCohesion () {
   //float neighbordist = 50;
    PVector sum = new PVector(0, 0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : friends) {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < coheseRadius)) {  
        sum.add(other.pos); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      
      PVector desired = PVector.sub(sum, pos);  
      //return desired.setMag(0.05);
      return desired;
    } 
    else {
      return new PVector(0, 0, 0);
    }
  }

  // Redundant Draw function
  public void drawr () {
    for ( int i = 0; i < friends.size(); i++) {
      stroke(90);
      //line(this.pos.x, this.pos.y, f.pos.x, f.pos.y);
    }
    noStroke();
    fill(shade, 90, 200);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    //rotate(move.heading());
    rotateX(move.x);
    rotateY(move.y);
    rotateZ(move.z);
    beginShape();
    vertex(15 * globalScale, 0);
    vertex(-7* globalScale, 7* globalScale);
    vertex(-7* globalScale, -7* globalScale);
    endShape(CLOSE);
    popMatrix();
  }
  
  // Draw function for individual character
  public void drawit() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    //rotate(move.heading());
    float x = move.x;
    float y = move.y;
    float z = move.z;
    float yangle = asin(x/sqrt(x*x + z*z));
    float xangle = -asin(y/sqrt(y*y + z*z));
    if(z>=0) {
      // This is definitely correct.
      //println("Z>0  "+random(10));
      rotateY(yangle);
      rotateX(xangle);
    } else if (z<0) {
      //println("Z<0  "+random(10));
      rotateX(PI);
      rotateY(yangle);
      rotateX(-xangle);
    }
    //rotateY(-PI/2);
    stroke(0);
    float t = 5*globalScale;
    // this pyramid has 4 sides, each drawn as a separate triangle
    // each side has 3 vertices, making up a triangle shape
    // the parameter " t " determines the size of the pyramid
    beginShape(TRIANGLES);
  
    //fill(150, 0, 0, 100);
    fill(shade, 90, 200);
    vertex(-t, -t, -t);
    vertex( t, -t, -t);
    vertex( 0, 0, 2*t);
  
    //fill(0, 150, 0, 100);
    fill(shade, 90, 200);
    vertex( t, -t, -t);
    vertex( t, t, -t);
    vertex( 0, 0, 2*t);
  
    //fill(0, 0, 150, 100);
    fill(shade, 90, 200);
    vertex( t, t, -t);
    vertex(-t, t, -t);
    vertex( 0, 0, 2*t);
  
    //fill(150, 0, 150, 100);
    fill(shade, 90, 200);
    vertex(-t, t, -t);
    vertex(-t, -t, -t);
    vertex( 0, 0, 2*t);
  
    endShape();
    popMatrix();
  }

  // update all those timers!
  public void increment () {
    thinkTimer = (thinkTimer + 1) % 5;
  }

  public void wrap () {
    //println("wrap was called");
    pos.x = (pos.x) % 500;
    pos.y = (pos.y) % 500;
    println("after wrap x and y are "+pos.x + " " + pos.y);
    //pos.z = (pos.z + height) % height;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Boids" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
