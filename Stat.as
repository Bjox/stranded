package{
	
	import flash.text.*;
	import flash.display.*;
	
	public class Stat extends MovieClip{
		
		private var heading = new TextField();
		private var tekst = new TextField();
		private var enhet:String;
		private var tekstFormat:TextFormat = new TextFormat();
		
		public function Stat(header:String,color,enhet:String = ""):void{
			tekstFormat.font = "_typewriter";
			tekstFormat.size = 16;
			tekstFormat.align = "left";
			tekstFormat.bold = true;
			tekstFormat.color = 0xFFFFFF;
			
			this.enhet = enhet;
			
			heading.selectable = false;
			heading.text = header;
			heading.height = 20;
			heading.setTextFormat(tekstFormat);
			
			tekstFormat.color = color;
			tekstFormat.bold = true;
			
			tekst.width = 100;
			tekst.height = 20;
			tekst.selectable = false;
			tekst.x = heading.width + 10;

			addChild(heading);
			addChild(tekst);
		}

		
		public function update(val:Number):void{
			var a:Number = Math.round(val*10);
			tekst.text = String(a/10) + " " + enhet;
			tekst.setTextFormat(tekstFormat);
		}
		
		public function updateColor(val:Number,color):void{
			tekstFormat.color = color;
			update(val);
		}
		
	}
}