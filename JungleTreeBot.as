package{
	
	import flash.display.*;
	
	public class JungleTreeBot extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "jungletreebot";
		public var col:Boolean = true;
		public var health:int = 100;
		public var dropItems:Array = new Array({type:Trunk, amount:2},{type:Vine, amount:Math.floor(Math.random()*3)});
		public var høyde:int = 2;
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}
	}
}