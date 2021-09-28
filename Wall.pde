public class Wall {
   
   private PVector position;
   private PVector dimensions;
   
   public Wall(PVector position, PVector dimensions) {
      this.position = position;
      this.dimensions = dimensions;
   }
   
   public void display(PGraphics canvas) {
      //canvas.line(p1.x, p1.z, p2.x, p2.z);
      float topLeftX = position.x - dimensions.x / 2;
      float topLeftY = position.z - dimensions.z / 2;
      
      noStroke();
      canvas.rect(position.x - dimensions.x / 2, position.z - dimensions.z / 2, dimensions.x, dimensions.z);
   }
   
}
