package{
	
	import flash.display.*;
	
	public class PineTreeBunn extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "pinetreebunn";
		public var col:Boolean = true;
		public var health:int = 150;
		public var dropItems:Array = new Array({type:Trunk, amount:0},{type:Branch, amount:0});
		public var høyde:int;
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}
		
		public function PineTreeBunn(høyde:int):void{
			dropItems[0].amount = høyde;
			dropItems[1].amount = høyde;
			this.høyde = høyde;
		}

	}
}