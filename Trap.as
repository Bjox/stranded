package{
	
	import flash.display.*;
	
	public class Trap extends Entity{
		
		public var xx:int;
		public var yy:int;
		public const label = "trap";
		public var col:Boolean = true;
		public var health:int = 5;
		public var dropItems:Array = new Array({type:Stick, amount:3},{type:Vine, amount:2});
		public var høyde:int = 1;
		
		public function Trap():void{
			hasLocEvent = true;
		}
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}
		
		public function trapCheck():Boolean{
			if(Math.random() > 0.6)return true;
			else return false;
		}
		
		public function locEvent(){
			activeLocEvent = true;
			locEventWindow = new Window_mc(-32,-96,96,64);
			locEventWindow.addAction("", true, null, 0, 0, 0, "Empty", null);
			addChild(locEventWindow);
			locEventWindow.alpha = 0.9;
			//locEventWindow.addEventListener(MouseEvent.CLICK, klikk)
		}
		
		/*public function klikk(evt){
			removeLocEvent();
			clicked = true;
			dispatchEvent(new Event(Event.CHANGE));
		}*/
		
		public function removeLocEvent():void{
			if(activeLocEvent){
				activeLocEvent = false;
				removeChild(locEventWindow);
			}
		}

	}
}