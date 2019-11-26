package{
	
	import flash.display.*;
	import flash.events.*;
	
	public class Mob extends MovieClip{
		
		public var distToGo = {x:Number, y:Number};
		public var vel:Number = 1;
		public var xx:uint;
		public var yy:uint;
		public var moving:Boolean;
		public var dir:String;
		public var hp:Number = 50;
		public var index:uint;
		public var dropItems:Array = new Array();
		
		
		public function Mob():void{
			this.addEventListener(Event.ENTER_FRAME, frame);
			distToGo.x = 0;
			distToGo.y = 0;
		}
		
		public function hurt(dmg:Number):Boolean{
			var dead:Boolean;
			hp -= dmg;
			if (hp <= 0) dead = true;
			return dead;
		}
		
		public function pos(xCord:uint, yCord:uint){
			x = 32*xCord;
			y = 32*yCord;
			
			xx = xCord;
			yy = yCord;
		}
		
		
		public function move(dir:String):void{		
			if (dir == "right" && !moving){
				moving = true;
				distToGo.x = 32;
				xx++;
			}
			if (dir == "left" && !moving){
				moving = true;
				distToGo.x = -32;
				xx--;
			}
			if (dir == "up" && !moving){
				moving = true;
				distToGo.y = -32;
				yy--;
			}
			if (dir == "down" && !moving){
				moving = true;
				distToGo.y = 32;
				yy++;
			}
			moving = true;
			gotoAndStop(dir);
		}
		
		
		
		public function frame(evt):void{
			if (distToGo.x != 0){
				if (distToGo.x > 0) {
					x += vel;
					distToGo.x -= vel;
				}
				if (distToGo.x < 0) {
					x -= vel;
					distToGo.x += vel;
				}
			}
			
			if (distToGo.y != 0){
				if (distToGo.y > 0) {
					y += vel;
					distToGo.y -= vel;
				}
				if (distToGo.y < 0) {
					y -= vel;
					distToGo.y += vel;
				}
			}
			
			if (distToGo.x == 0 && distToGo.y == 0) moving = false;

		}
		
	}
	
}