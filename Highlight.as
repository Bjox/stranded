﻿package{
	
	import flash.display.*;
	
	public class Highlight extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "highlight";
		public var col:Boolean = true;
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}

	}
}