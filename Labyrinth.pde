PGraphics canvas;

Point p1, p2;
Spring s;

void setup() {
   size(800, 600);
   noSmooth();
   frameRate(60);

   canvas = createGraphics(400, 300);
   
   p1 = new Point(200, 0, 140, 1, 1);
   p2 = new Point(200, 0, 160, 1, 1);
   s = new Spring(p1, p2, 30, 0.05, 0.05);
}

void draw() {
   s.applyForce();
   p1.update();
   p2.update();
   
   canvas.beginDraw();
   canvas.background(0);
   
   s.display(canvas);
   
   canvas.endDraw();
   
   // Draw canvas
   image(canvas, 0, 0, width, height);
}
