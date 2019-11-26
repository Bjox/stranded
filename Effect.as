package{
	
	import flash.display.*;
	
	public class Effect extends MovieClip{
		
		
		public function place(x,y,faceDir:String):void{
			this.y = (y*32) + 16;
			this.x = (x*32) + 16;
			
			if (faceDir == "right"){
				this.x += 20;
			}
			if (faceDir == "down"){
				this.y += 20;
				this.rotation = 90;
			}
			if (faceDir == "left"){
				this.x -= 20;
				this.rotation = 180;
			}
			if (faceDir == "up"){
				this.y -= 20;
				this.rotation = 270;
			}
			
		}
		
	}
}