PGraphics canvas;

void setup() {
   size(800, 600);
   noSmooth();
   frameRate(60);

   canvas = createGraphics(400, 300);
}

void draw() {
   canvas.beginDraw();
   canvas.background(0);
   canvas.stroke(255);
   canvas.line(0, 0, mouseX / 2, mouseY / 2);
   canvas.endDraw();
   image(canvas, 0, 0, width, height);
}
