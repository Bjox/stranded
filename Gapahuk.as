package{
	
	import flash.display.*;
	import flash.events.*;
	
	public class Gapahuk extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "gapahuk";
		public var col:Boolean = true;
		public var health:int = 10;
		public var dropItems:Array = new Array({type:Trunk, amount:2},{type:Branch, amount:3});
		public var høyde:int = 1;
		public var clicked:Boolean=false;
		public var locEventEnabled:Boolean;

		public function Gapahuk():void{
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
			locEventWindow = new Window_mc(-32,-96,96,64);
			locEventWindow.addAction("", locEventEnabled, null, 0, 0, 0, "Sleep", null);
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