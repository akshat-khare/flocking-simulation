# flocking-simulation
The repository contains the code for simulating the flocking movement of boids. The project is done in [Processing][1] and implements the flocking behaviour of boids in 3D. This project is a part of COP290 course at IIT Delhi.

## About
Boids is an **artificial life program**, developed by Craig Reynolds in 1986, which simulates the flocking behaviour of birds. The name "boid" corresponds to a shortened version of "bird-oid object", which refers to a bird-like object.  
The boids move individually, but ahdering to some set of rules. The four most basic rules (that are also implemented in the current project) describing the individual behaviour are:  
1. Separation: steer to avoid crowding local flockmates.  
2. Alignment: steer towards the average heading of local flockmates.  
3. Cohesion: steer to move toward the average position (center of mass) of local flockmates.  
4. Obstacle Avoidance: steer to move away from a obstacle in the way.  

## Technologies Used
Processing is a flexible software sketchbook that is used for rendering animations easily and interactively. The present project is also made on Processing.  
The code can be used either by downloading Processing for your respective OS, or alternatively, an standalone Java application can be used as well.

## Documentation
The documentation, mathematical model and specification for the current project can be found in the /doc/ folder in the root repository folder.

## Authors  
Akshat Khare [@akshat-khare][2]  
Divyanshu Saxena [@DivyanshuSaxena][3]  

## References
1. [Boid Flocking Simulation by Craig W. Reynolds][4]  
2. [Processing 2D Flocking Simulation Example][5]  
3. [In-formation Flocking Behaviour][6]

[1]: https://processing.org/
[2]: https://github.com/akshat-khare/
[3]: https://github.com/DivyanshuSaxena/
[4]: https://www.red3d.com/cwr/boids/
[5]: https://processing.org/examples/flocking.html
[6]: https://pdfs.semanticscholar.org/ea6d/3c59ef1166baeb0679aef553df6ebf7765c7.pdf
