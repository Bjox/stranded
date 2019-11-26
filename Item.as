package{
	
	import flash.display.*;
	import flash.events.*;
	
	public class Item extends MovieClip{
		
		public var classification:String = "item";
		private var vy:Number = 0.0;
		private var startV:Number = 6 + (Math.random()*2);
		private var spawnMovement:Boolean = true;
		private var t:int = Math.floor(Math.random()*16);
		public var usable:Boolean = false;
		private var dark:Shadow = new Shadow();
		public var xx;
		public var yy;
		public var weight:uint = 2;
		public var tool:Boolean;
		//NB! shadow
		
		//actions
		public var actions = {energy:Number, hunger:Number};
		
		public function Item():void{
			actions.energy = 0;
			actions.hunger = 0;
		}
		
		public function spawn():void{
			dark.x = x;
			dark.y = y;
			addChild(dark);
			this.addEventListener(Event.ENTER_FRAME, loop);
			vy = startV;
		}
		
		private function loop(evt):void{
			if (spawnMovement){
				y -= vy;
				vy --;
				if (vy <= -startV){
					spawnMovement = false;
					vy = 0.3;
				}
			}
			else{
				y -= vy;
				if (t == 20){
					vy *= -1;
					t = 0;
				}
				else
					t++;
			}
		}
		
	}
}