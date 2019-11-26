package{
	
	import flash.display.*;
	import flash.events.*;
	
	 public class Tile extends MovieClip{
		 
		public var classification:String = "tile";
		public var item;
		public var dropItem;
		public var dropItemAmount:uint;
		public var freshWater:Boolean = false;
		
		
		public function addOverlay(type:Class, rotAngle:uint = 0):void{
			var overlay = new type();
			overlay.rotation = rotAngle * 90;
			switch (rotAngle){
				case 1:
					overlay.x += 32;
					break;
				case 2:
					overlay.x += 32;
					overlay.y += 32;
					break;
				case 3:
					overlay.y += 32;
					break;
			}
			addChild(overlay);
		}
		 
	 }
}