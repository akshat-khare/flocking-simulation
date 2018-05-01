# flocking-simulation
The repository contains the code for simulating the flocking movement of boids. The project is done in [Processing][1] and implements the flocking behaviour of boids in 3D. This project is a part of COP290 course at IIT Delhi.

## About
Boids is an **artificial life program**, developed by Craig Reynolds in 1986, which simulates the flocking behaviour of birds. The name "boid" corresponds to a shortened version of "bird-oid object", which refers to a bird-like object.  
The boids move individually, but ahdering to some set of rules. The three most basic rules (that are also implemented in the current project) describing the individual behaviour are:  
1. Separation: steer to avoid crowding local flockmates.  
2. Alignment: steer towards the average heading of local flockmates.  
3. Cohesion: steer to move toward the average position (center of mass) of local flockmates.  

Besides, the following rules are also implemented for a more real simulation:
1. Boundary Restriction: steer away from a boundary so as to remain within a certain confinement.
2. Obstacle Avoidance: steer to move away from a obstacle in the way.  
3. Energy Considerations: lose energy on moving upwards and gain energy on moving downwards (due to gravity).  

## Usage
1. The standalone applications for major Operating Systems can be found in the /Boids/ folder in the respective application.* folder.  
2. Besides, Processing can be downloaded from the [official website][7]. Once installed, any .pde file in the Boids/ can be opened and the application can be run from the top left icon.
### Functionalities
Key ',' -> Change Boundary to Cube.  
Key '.' -> Change Boundary to Sphere.  
Key '-' -> Decrease Scale (Size).
Key '=' -> Increase Scale (Size).  
Key 'E' -> Enable/Disable Energy Effect. 
Key 'P' -> Pause Simulation.  
Key 'S' -> Run the Simulation Frame by Frame.  
Key 'C' -> Continue Simulation.  
Key 'B' followed by click -> Add Boids.  
Key 'A' followed by click -> Add Obstacles.  
Key '1' -> Enable/Disable Alignment Rule.  
Key '2' -> Enable/Disable Separation Rule.  
Key '3' -> Enable/Disable Cohesion Rule.  
Key '4' -> Enable/Disable Obstacle Avoidance Rule.  

## Technologies Used
Processing is a flexible software sketchbook that is used for rendering animations easily and interactively. The present project is also made on Processing.  
The code can be used either by downloading Processing for your respective OS, or alternatively, an standalone Java application can be used as well.

## Documentation
The documentation, mathematical model and specification for the current project can be found in the /doc/ folder in the root repository folder.

## Authors  
[Akshat Khare][2]  
[Divyanshu Saxena][3]  

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
[7]: https://processing.org/download/
