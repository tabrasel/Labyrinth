PGraphics canvas;
Camera camera;
PhysicsManager pm;

Maze maze;
Clew clew;

void setup() {
   size(800, 600);
   noSmooth();
   frameRate(60);
   
   canvas = createGraphics(400, 300);
   pm = new PhysicsManager();
   
   maze = new Maze(pm);
   clew = new Clew(pm);
   
   camera = new Camera(new PVector(140, 0, 140), new PVector(400, 300));
}

void draw() {
   pm.update();
   
   canvas.beginDraw();
   canvas.background(0);
   
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
