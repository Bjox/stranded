package
{
	import flash.display.*;
	import flash.display.Stage;
	import flash.events.*;
	import flash.geom.*;
	
	public class Spiller extends MovieClip
	{
		public var vel:int;
		private var runVel:int = 16;
		
		private var høyre:Boolean = false;
		private var venstre:Boolean = false;
		private var opp:Boolean = false;
		private var ned:Boolean = false;
		private var running:Boolean = false;
		public var setHighlight:Boolean = false;
		public var xCord:int;
		public var yCord:int;
		public var faceDir:String = "down";
		public var damage:int = 5;
		

		
		
		public function plassering (xPos:Number, yPos:Number, scale:Number):void
		{
			x = xPos;
			y = yPos;
			scaleX = scale;
			scaleY = scale;
		}
		
		public function tastNed(evt)
		{
			//trace(evt.keyCode);
			switch(evt.keyCode)
			{
				case 68: 
				if(!setHighlight && !høyre)
				{
					høyre = true;
					gotoAndPlay("rightS");
					faceDir = "right";
				}
				break;
				
				case 65: 
				if(!setHighlight && !venstre)
				{
					venstre = true;
					gotoAndPlay("leftS");
					faceDir = "left";
				}
				break;
				
				case 87: 
				if(!setHighlight  && !opp)
				{
					opp = true;
					gotoAndPlay("upS");
					faceDir = "up";
				}
				break;
				
				case 83: 
				if(!setHighlight  && !ned)
				{
					ned = true;
					gotoAndPlay("downS");
					faceDir = "down";
				}
				break;
				
				case 16: running = true;
				break;
				
				
			}
		}
		
		public function tastOpp(evt)
		{
			switch(evt.keyCode)
			{
				case 68: høyre = false;
				break;
				
				case 65: venstre = false;
				break;
				
				case 87: opp = false;
				break;
				
				case 83: ned = false;
				break;
				
				case 16: running = false;
				break;
				
				
			}
			//if(!bevegelse) gotoAndStop(faceDir);
		}
		
		public function stopAni():void{
			gotoAndStop(faceDir);
		}
	}
}