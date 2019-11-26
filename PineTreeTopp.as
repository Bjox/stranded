package{
	
	import flash.display.*;
	
	public class PineTreeTopp extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "pinetreetopp";
		public var col:Boolean = true;
		public var health:int = -1;
		public var dropItems:Array = new Array();
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}

	}
}