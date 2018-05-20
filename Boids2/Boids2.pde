int customframerate=60;
ArrayList<Boid> boids;
ArrayList<Avoid> avoids;
Boundary box;
//PImage bg;
//volatile PImage tempbg;
float imgfac = 0;

//peasy cam
import peasy.PeasyCam;
PeasyCam cam;

float globalScale = 0.83;
float thresholdEnergy = 30;
float energyFactor = 0.2;
int rotate = 1;
String tool = "boids";
String environment = "sphere";

// boid control
float friendRadius;
float crowdRadius;
float avoidRadius;
float avoidWallRadius;
float coheseRadius;

// Hyper Parameters
float FRIENDFACTOR = 45;
float CROWDFACTOR = 20;
float AVOIDFACTOR = 20;
float WALLFACTOR = 40;

int boundary;
int currentBoid;

boolean option_friend = true;
boolean option_crowd = true;
boolean option_avoid = true;
boolean option_noise = true;
boolean option_cohese = true;
boolean option_energy = false;
String boidshape = "triangle";
// gui crap
float messageTimer = 0;
String messageText = "";

void settings  () {
  size(1800, 1000, P3D);
}

void setup () {
  //setup
  cam = new PeasyCam(this,(double) width/2,(double) height/2,(double) 200, (double) 700);
  frameRate(customframerate);
  //bg = loadImage("data/pansky.jpg");
  //imgfac = (bg.width * height )/bg.height;
  //bg.get(0,0,500,200);
  //bg.resize((int) imgfac,height);
  //tempbg = bg.get(0,0,width, height);
  //println("width and height are " + width + " " +height + " finimage width and height are " + bg.width + " " + bg.height);
  textSize(16);
  textAlign(CENTER,BOTTOM);
  recalculateConstants();
  boids = new ArrayList<Boid>();
  avoids = new ArrayList<Avoid>();
  setupWalls();
  println(boundary + " is boundary");
  int id = 0;
  for (int i = 0; i < 2000; i+= 1) {
      id = id + 1;
      // println("New Boid added with id:" +id);
      boids.add(new Boid(random(-100,100), random(-100,100), random(-100,100), id));
  }
  currentBoid = 0;  
}

void recalculateConstants () {
  //stroke(150);
  friendRadius = FRIENDFACTOR * globalScale;
  crowdRadius = CROWDFACTOR * globalScale;
  avoidRadius = AVOIDFACTOR * globalScale;
  avoidWallRadius = WALLFACTOR * globalScale;
  coheseRadius = 1.5 * friendRadius;
  //println("maxspeed is " +maxSpeed);
  //println("friendradius is " +friendRadius);
  //println("crowdRadius is " +crowdRadius);
  //println("avoidRadius is " +avoidRadius);
  //println("coheseradius is " +coheseRadius);
  //println("width is " +width);
  //println("height is " +height);
}


void setupWalls() {
  boundary = (int)(550 * globalScale);
  box = new Boundary(boundary);
}

void setupCircle() {
  avoids = new ArrayList<Avoid>();
  for (int x = 0; x < 50; x+= 1) {
    float dir = (x / 50.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.4, height * 0.5 + sin(dir)*height*.4, 0));
  }
}

void draw () {
  fill(0);
  //background(0);
  noFill();
  stroke(255);
  strokeWeight(1);  
  box.drawsur();

  noStroke();
  colorMode(HSB);
  for (int i = 0; i <boids.size(); i++) {
    Boid current = boids.get(i);
    // println("Boid id: " + i + " " + current.id + " is at "+ current.pos.x +" "+current.pos.y + " " + current.pos.z + " velocity is " + current.move.x + " " + current.move.y + " " + current.move.z );
    currentBoid = i;
    //println(currentBoid + " " + random(10));
    //thread("calcSingle");
    current.moveBoid();
    current.drawBoid();
  }

  for (int i = 0; i <avoids.size(); i++) {
    Avoid current = avoids.get(i);
    current.go();
    current.drawAvoid();
  }

  if (messageTimer > 0) {
    messageTimer -= 1;
  }
  drawGUI();
}

void calcSingle () {
  //println(currentBoid);
  Boid boid = boids.get(currentBoid);
  currentBoid = (currentBoid+1)%1000;
  boid.moveBoid();
  return;
}

void keyPressed () {
  if (key == 'b') {
    tool = "boids";
    message("Add boids");
  } else if (key == 'a') {
    tool = "avoids";
    message("Place obstacles");
  } else if (key == '-') {
    message("Decreased scale");
    globalScale *= 0.8;  
  } else if (key == '=') {
    message("Increased Scale");
    globalScale /= 0.8;
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
  } else if (key == 'n') {
    option_noise = option_noise ? false : true;
    message("Turned noise " + on(option_noise));
  } else if (key == 'e') {
    option_energy = option_energy ? false : true;
    message("Turned energy effect " + on(option_energy));
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
  } else if(key =='t'){
    if(boidshape =="pyramid"){
      boidshape = "triangle";
    }else{
      boidshape = "pyramid";
    }
    
  }
  //println("calling recalculate");
  recalculateConstants();
  //println("recalculate called");
}

void drawGUI() {
  if (messageTimer > 0) {
    fill((min(30, messageTimer) / 30.0) * 255.0);
    text(messageText, boundary/2, boundary/2);
  }
}

String s(int count) {
  return (count != 1) ? "s" : "";
}

String on(boolean in) {
  return in ? "on" : "off";
}

void mousePressed () {
  switch (tool) {
  case "boids":
    float xcoor = mouseX-(width/2);
    float ycoor = mouseY-(height/2);
    if (xcoor > (boundary/2) || xcoor < (-boundary/2)) {
      xcoor = (abs(xcoor)) % (boundary/2);
    }
    if (ycoor > (boundary/2) || ycoor < (-boundary/2)) {
      ycoor = (abs(ycoor)) % (boundary/2);
    }
    boids.add(new Boid(xcoor, ycoor, random(-100,100), boids.size()+1));
    message(boids.size() + " Total Boids");
    break;
  case "avoids":
    xcoor = mouseX-(width/2);
    ycoor = mouseY-(height/2);
    if (xcoor > (boundary/2) || xcoor < (-boundary/2)) {
      xcoor = abs(xcoor) % (boundary/2);
    }
    if (ycoor > (boundary/2) || ycoor < (-boundary/2)) {
      ycoor = abs(ycoor) % (boundary/2);
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

//void drawText (String s, float x, float y) {
//  float textx = x-(width/2);
//  float texty = y-(height/2);
//  fill(200);
//  text(s, boundary/2, boundary/2);
//  //fill(200);
//  //text(s,  boundary/2-1, boundary/2-1);
//}


void message (String in) {
  messageText = in;
  messageTimer = (int) frameRate * 3;
  //drawText(messageText,0,0);
}

//Avoid class
class Avoid {
  PVector pos;
   
    Avoid (float xx, float yy, float zz) {
      pos = new PVector(xx,yy,zz);
    }
   
   void go () {
     
   }
   
   //void setup () {
   // stroke(255);
   // strokeWeight(1);
   // frameRate(customframerate);
   //}
   
   void drawAvoid () {
     pushMatrix();
     fill(0, 255, 200);
     translate(pos.x, pos.y, pos.z);
     box(10);  
     popMatrix();
   }
}


//Boundary class

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
     //tempbg = bg.get(thiwid,0,width, height);
   }
   void drawsur () {
     
     boundcount++;
     //float begwid = (frameCount%(1256))/1256;
     //if((begwid/1256) * width + width >bg.width || begwid >=1256){
     //  println("exceeded " + begwid);
     //  begwid = 0;
     //}
     //thiwid = (int) (begwid*width)/1256;
     //tryme = bg.get(thiwid,0,width, height);
     //println("size of to be rendered image is " + tryme.width +" "+ tryme.height + " width is " + width);
     //tryme.resize(width,height);
     //if(frameCount%10==1){
     //  //tempbg = bg.get(thiwid,0,width, height);
     //  begwid++;
     //  //background(tryme);
     //}
     //thread("changeBackground");
     //background(tempbg);
     //begwid++;
     
     //background(bg.get(thiwid,0,width, height));
     background(0);
     //image(bg,-thiwid,0,-thiwid+width, height);
     
      //background(0);
      translate(width/2, height/2, 200);
      if (rotate == 1)
        rotateY(frameCount / 200.0); 
  
      if(environment == "box"){
        box(boundary);
      }else if(environment == "sphere"){
        //boundary = boundary;
        sphereDetail(20,15);
        sphere((boundary * 0.866));
      } 
      //noLoop();
   }
}

// Single class
class Boid {
  // main fields
  PVector pos;
  PVector move;
  float shade;
  int id;
  ArrayList<Boid> friends;
  float maxSpeed;
  float energy;

  // timers
  int thinkTimer = 0;

  // Hyper Parameters
  float SPEEDFACTOR = 1.5;
  float ALIGNMULT = 1.0;
  float SEPARATEMULT = 10.0;
  float AVOIDMULT = 1.0;
  float NOISEMULT = 0.1;
  float COHESEMULT = 0.005;
  int MAXFRIENDS = 7;

  Boid (float xx, float yy, float zz, int ii) {
    pos = new PVector(0, 0, 0);
    pos.x = xx;
    pos.y = yy;
    pos.z = zz;
    id = ii;
    maxSpeed = SPEEDFACTOR * globalScale;
    energy = 100;
    float angle = random(TWO_PI);
    move = new PVector(cos(angle), sin(angle), cos(angle));
    thinkTimer = int(random(10));
    shade = random(255);
    friends = new ArrayList<Boid>();
  }
  
  void moveBoid () {
    increment();
    if (thinkTimer == 0 ) {
      getFriends();
    }
    flock();
    pos.add(move);
  }

  void flock () {
    PVector align = getAlignment();
    PVector separate = getSeparation(); 
    PVector avoidObjects = avoidAvoids(); 
    PVector avoidWalls =new PVector(0,0,0);
    
    if(environment == "box"){
       avoidWalls = getAvoidWallsBox();
    }else{
       avoidWalls = getAvoidWallsSphere();
    }
    
    PVector noise = new PVector(random(2) - 1, random(2) - 1, random(2) - 1);
    PVector cohese = getCohesion();

    align.mult(ALIGNMULT);
    if (!option_friend) align.mult(0);
    
    separate.mult(SEPARATEMULT);
    if (!option_crowd) separate.mult(0);
    
    avoidObjects.mult(AVOIDMULT);
    if (!option_avoid) avoidObjects.mult(0);

    avoidWalls.mult(AVOIDMULT);
    if (!option_avoid) avoidWalls.mult(0);

    noise.mult(NOISEMULT);
    if (!option_noise) noise.mult(0);

    cohese.mult(COHESEMULT);
    if (!option_cohese) cohese.mult(0);
    
    stroke(0, 255, 160);

    move.add(align);
    move.add(separate);
    move.add(avoidObjects);
    move.add(avoidWalls);
    move.add(noise);
    move.add(cohese);

    move.limit(maxSpeed);
    
    if (option_energy) {
      if (move.y > 0) {
        energy += 1.5;
      } else {
        energy -= 1.5;
      }
      PVector energyEffect = getEnergy();
      move.add(energyEffect);
    }
    
    shade += getAverageColor() * 0.03;
    shade += (random(2) - 1) ;
    shade = (shade + 255) % 255; //max(0, min(255, shade));
  }

  void getFriends () {
    ArrayList<Boid> nearby = new ArrayList<Boid>();
    for (int i =0; i < boids.size(); i++) {
      Boid test = boids.get(i);
      if (test == this) continue;
      if (abs(test.pos.x - this.pos.x) < friendRadius &&
        abs(test.pos.y - this.pos.y) < friendRadius &&
        abs(test.pos.z - this.pos.z) < friendRadius ) {
        nearby.add(test);
      }
      //if (i==MAXFRIENDS) {
      //  break;
      //}
    }
    friends = nearby;
  }

  float getAverageColor () {
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

  PVector getAlignment () {
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

  PVector getSeparation() {
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Boid other : friends) {
      float d = PVector.dist(pos, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < crowdRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos);
        //diff = diff.mult((PVector.dot(diff, move))/20);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    return steer;
  }

  PVector avoidAvoids() {
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
  
  float getDistance (PVector p, float plane[]) {
    float distance = abs(p.x*plane[0] + p.y*plane[1] + p.z*plane[2] + plane[3])/sqrt(plane[0]*plane[0] + plane[1]*plane[1] + plane[2]*plane[2]);
    return distance;
  }
  
  // Avoid Walls (to be improved)
  PVector getAvoidWallsBox () {
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

    return steer;
  }
  
    PVector getAvoidWallsSphere () {
    //float desiredseparation = 25.0f;
    PVector steer = pos.copy();
    float dist = pos.mag();
    float radius = boundary * 0.866;
    steer.normalize();
    steer.mult(-1);
    if(dist>radius){
      steer.mult(dist);
    }else{
      steer.div(radius - dist);
    }
    return steer;  
  }
  
  
  PVector getCohesion () {
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
  
  PVector getEnergy() {
    PVector steer = new PVector(0,0,0);
    if (energy < thresholdEnergy) {
      steer.y += energyFactor * (thresholdEnergy - energy);
    }
    return steer;
  }


  
  // Draw function for individual character
  void drawBoid() {
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
    float t2 = 0.9*globalScale;
    float t = 2.5*globalScale;
    // this pyramid has 4 sides, each drawn as a separate triangle
    // each side has 3 vertices, making up a triangle shape
    // the parameter " t " determines the size of the pyramid
    if(boidshape== "pyramid"){
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
    }
    if(boidshape == "triangle"){
      beginShape(TRIANGLES);
    fill(shade, 90, 200);
    
    //body
    vertex(0, 0, -6*t2);
    vertex(0, 3*t2, -20*t2);
    vertex(0, 0, 8*t2);
    
    vertex(0, 0.5*t2, -4*t2);
    vertex(-6*t2,((frameCount/2)%6 -3)*t2, -2*t2);
    vertex(0, 0, 2*t2);
    
    vertex(0, 0, 2*t2);
    vertex(6*t2, ((frameCount/2)%6 -3)*t2, -2*t2);
    vertex(0, 0.5*t2, -4*t2);
    //popMatrix();
    endShape();
     
    }
    popMatrix();
  }

  // update all those timers!
  void increment () {
    thinkTimer = (thinkTimer + 1) % 5;
  }

  void wrap () {
    //println("wrap was called");
    pos.x = (pos.x) % 500;
    pos.y = (pos.y) % 500;
    println("after wrap x and y are "+pos.x + " " + pos.y);
    //pos.z = (pos.z + height) % height;
  }
}
