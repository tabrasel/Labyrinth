PGraphics canvas;
PhysicsManager pm;

void setup() {
   size(800, 600);
   noSmooth();
   frameRate(60);
   
   canvas = createGraphics(400, 300);
   pm = new PhysicsManager();
}

void draw() {
   pm.update();
   
   canvas.beginDraw();
   canvas.background(0);
   
   s.display(canvas);
   
   canvas.endDraw();
   
   // Draw canvas
   image(canvas, 0, 0, width, height);
}
