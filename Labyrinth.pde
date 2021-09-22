PGraphics canvas;
PhysicsManager pm;
Clew clew;

void setup() {
   size(800, 600);
   noSmooth();
   frameRate(60);
   
   canvas = createGraphics(400, 300);
   
   pm = new PhysicsManager();
   
   clew = new Clew(pm);
}

void draw() {
   pm.update();
   
   canvas.beginDraw();
   canvas.background(0);
   
   clew.display(canvas);
   
   canvas.endDraw();
   
   // Draw canvas
   image(canvas, 0, 0, width, height);
}
