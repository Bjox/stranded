package{
	
	import flash.display.*;
	
	public class TorchEnt extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "torch";
		public var col:Boolean = false;
		public var health:int = 1;
		public var dropItems:Array = new Array({type:Torch, amount:2});
		public var høyde:int = 1;
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}

	}
}