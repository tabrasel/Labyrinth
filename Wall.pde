public class Wall {
   
   private PVector p1, p2;
   public static final float THICKNESS = 2;
   
   public Wall(PVector p1, PVector p2) {
      this.p1 = p1;
      this.p2 = p2;
   }
   
   public void display(PGraphics canvas) {
      canvas.line(p1.x, p1.z, p2.x, p2.z);
   }
   
}
