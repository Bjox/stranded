package{
	
	import flash.display.*;
	
	public class GrassToSandOuterTopLeft extends Tile{
		
		public var xx:int;
		public var yy:int;
		public const label = "grasstosandoutertopleft";
		public var col:Boolean = false;
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}
		
	}
}