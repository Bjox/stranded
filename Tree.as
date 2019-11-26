package{
	
	import flash.display.*;
	
	public class Tree extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "tree";
		public var col:Boolean = true;
		public var health:int = 60;
		public var a:uint 
		public var dropItems:Array;
		public var høyde:int = 1;
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}
		
		public function Tree(){
			if (Math.random() > 0.7) a = 1;
			dropItems = new Array({type:Trunk, amount:Math.ceil(Math.random()*2)}, {type:Apple, amount: a});
		}
		
	}
}