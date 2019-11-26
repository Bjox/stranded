package{
	
	import flash.display.*;
	
	public class PineTree2Bunn extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "pinetree2bunn";
		public var col:Boolean = true;
		public var health:int = 200;
		public var dropItems:Array = new Array({type:Trunk, amount:0},{type:Branch, amount:0});
		public var høyde:int;
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}
		
		public function PineTree2Bunn(høyde:int):void{
			dropItems[0].amount = høyde;
			dropItems[1].amount = høyde;
			this.høyde = høyde;
		}

	}
}