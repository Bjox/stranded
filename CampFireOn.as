package{
	
	import flash.display.*;
	import flash.events.*;
	
	public class CampFireOn extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "campfireon";
		public var col:Boolean = true;
		public var health:int = 30;
		public var dropItems:Array = new Array({type:Stone, amount:3});
		public var høyde:int = 1;
		public var clicked = false;
		
		public function CampFireOn():void{
			hasLocEvent = true;
		}
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}
		
		public function locEvent(){
			activeLocEvent = true;
			locEventWindow = new Window_mc(-42,-96,128,64);
			locEventWindow.addAction("", true, null, 0, 0, 0, "Roast meat", null);
			addChild(locEventWindow);
			locEventWindow.alpha = 0.9;
			locEventWindow.addEventListener(Event.CHANGE, klikk)
		}
		
		public function klikk(evt){
			removeLocEvent();
			clicked = true;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function removeLocEvent():void{
			if(activeLocEvent){
				activeLocEvent = false;
				removeChild(locEventWindow);
			}
		}

	}
}