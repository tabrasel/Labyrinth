PGraphics canvas;
Camera camera;
PhysicsManager pm;

Maze maze;
Clew clew;

Point myPoint;
Wall myWall;

void setup() {
   size(800, 600);
   noSmooth();
   frameRate(60);
   
   canvas = createGraphics(400, 300);
   pm = new PhysicsManager();
   
   maze = new Maze(pm);
   clew = new Clew(10, 10, pm);
   
   //myPoint = new Point(-5, 0, 20, 1, 10);
   //pm.addPoint(myPoint);
   
   //myWall = new Wall(new PVector(40, 0, 60), new PVector(80, 0, 30));
   //pm.addWall(myWall);
   
   camera = new Camera(new PVector(140, 0, 128), new PVector(400, 300));
}

void draw() {
   pm.update();
   
   canvas.beginDraw();
   canvas.background(0);
   
   //myPoint.display(canvas, camera);
   //myWall.display(canvas, camera);
   
   maze.display(canvas, camera);
   clew.display(canvas, camera);
   
   canvas.textSize(10);
   canvas.textAlign(LEFT, TOP);
   canvas.fill(255, 255, 255);
   canvas.text(int(frameRate), 0, 0);
   
   
   
   canvas.endDraw();
   
   // Draw canvas
   image(canvas, 0, 0, width, height);
}
