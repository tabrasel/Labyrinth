public class Camera {
   
   private PVector position;
   private PVector dimensions;
   
   public Camera(PVector position, PVector dimensions) {
      this.position = position;
      this.dimensions = dimensions;
   }
   
   public PVector getPosition() {
      return position;
   }
   
   public PVector getDimensions() {
      return dimensions;
   }
   
}
