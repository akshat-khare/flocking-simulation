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
    thinkTimer = int(random(10));
    shade = random(255);
    friends = new ArrayList<Boid>();
  }

  void go () {
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

  void flock () {
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

    align.mult(1.0);
    if (!option_friend) align.mult(0);
    
    separate.mult(10.0);
    if (!option_crowd) separate.mult(0);
    
    avoidObjects.mult(1.0);
    if (!option_avoid) avoidObjects.mult(0);

    noise.mult(0);
    if (!option_noise) noise.mult(0);

    cohese.mult(0.002);
    if (!option_cohese) cohese.mult(0);
    
    stroke(0, 255, 160);

    move.add(align);
    move.add(separate);
    move.add(avoidObjects);
    move.add(noise);
    move.add(cohese);

    move.limit(maxSpeed);
    
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
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    return steer;
  }

  PVector getAvoidAvoids() {
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

  // Redundant Draw function
  void drawr () {
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
  void drawit() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    //rotate(move.heading());
    rotateX(move.x);
    rotateY(move.y);
    rotateZ(move.z);
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
