package{
	
	import flash.display.*;
	
	public class PalmeTopp extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "palmetopp";
		public var col:Boolean = false;
		public var health:int = -1;
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}
		
	}
}