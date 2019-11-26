package{
	
	import flash.display.*;
	
	public class Grass extends Tile{
		
		public var xx:int;
		public var yy:int;
		public var label = "grass";
		public var col:Boolean = false;
		
		public function pos (xPos:int, yPos:int):void{
			xx = xPos;
			yy = yPos;
			
			x = xx*32;
			y = yy*32;
		}
		
		public function Grass():void{
			if (Math.random() > 0.97){
				var rand:Number = Math.random();
				var decal;
				if (rand < 0.25){
					decal = new Decal1();
					decal.x = 16;
					decal.y = 16;
					decal.rotation = Math.random()*360;
				}
				else if (rand > 0.25 && rand < 0.5){
					decal = new Decal2();
					decal.x = 16;
					decal.y = 16;
					decal.rotation = Math.random()*360;
				}
				else if (rand > 0.5 && rand < 0.75){
					decal = new Flower1();
					decal.x = (Math.random()*28)+2;
					decal.y = Math.random()*28;
					decal.gotoAndPlay(Math.ceil(Math.random()*40));
				}
				else{
					decal = new Flower2();
					decal.x = (Math.random()*28)+2;
					decal.y = Math.random()*28;
				}
				if(decal != null) addChild(decal);
				
			}
			
			if (Math.random() > 0.99){
				item = new StoneDecal();
				if (Math.random() < 0.75)dropItem = Stone;
				else dropItem = Flint;
				dropItemAmount = 1;
				item.x = (Math.random()*8)+12;
				item.y = (Math.random()*8)+12;
				addChild(item);
			}
		}
		
	}
}