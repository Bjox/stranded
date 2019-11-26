package{
	
	import flash.display.*;
	import flash.events.*;
	
	public class TrapClosed extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "trapclosed";
		public var col:Boolean = true;
		public var health:int = 5;
		public var dropItems:Array = new Array({type:Stick, amount:3},{type:Vine, amount:2});
		public var høyde:int = 1;
		public var clicked:Boolean = false;
		
		public function TrapClosed():void{
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
			locEventWindow = new Window_mc(-58,-96,128,64);
			locEventWindow.addAction("", true, null, 0, 0, 0, "Take food", null);
			addChild(locEventWindow);
			locEventWindow.alpha = 0.9;
			locEventWindow.addEventListener(MouseEvent.CLICK, klikk)
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