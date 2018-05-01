int customframerate=60;
Boid barry;
ArrayList<Boid> boids;
ArrayList<Avoid> avoids;
Boundary box;
PImage bg;
volatile PImage tempbg;
float imgfac = 0;

float globalScale = 1.13;
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
float messageTimer = 0;
String messageText = "";

void settings  () {
  size(1800, 1000, P3D);
}

void setup () {
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
  for (int i = 0; i < 1000; i+= 1) {
      id = id + 1;
      // println("New Boid added with id:" +id);
      boids.add(new Boid(random(-100,100), random(-100,100), random(-100,100), id));
  }
  //boids.add(new Boid(boundary/4, 0, 0, 0));
  //boids.add(new Boid(boundary/4 - 20, 0, 0, 1));
  
}

// haha
void recalculateConstants () {
  //stroke(150);
  //text(globalScale, boundary/2, boundary/2 );
  maxSpeed = 1.5 * globalScale;
  friendRadius = 40 * globalScale;
  crowdRadius = (friendRadius / 2);
  avoidRadius = 20 * globalScale;
  avoidWallRadius = 80 * globalScale;
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
  boundary = (int)(350 * globalScale);
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

void keyPressed () {
  if (key == 'q') {
    tool = "boids";
    message("Add boids");
  } else if (key == 'w') {
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
