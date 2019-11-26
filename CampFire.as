package{
	
	import flash.display.*;
	
	public class CampFire extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "campfire";
		public var col:Boolean = true;
		public var health:int = 30;
		public var dropItems:Array = new Array({type:Stone, amount:4}, {type:Trunk, amount:2});
		public var høyde:int = 1;
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}

	}
}