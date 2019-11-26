package{
	
	import flash.display.*;
	
	public class WaterRock extends Tile{
		
		public var xx:int;
		public var yy:int;
		public const label = "waterrock";
		public var col:Boolean = true;
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}
		
	}
}