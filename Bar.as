package{
	
	import flash.display.*;
	import flash.text.*;
	
	public class Bar extends MovieClip{
		
		public var bar;
		private var tekstFormat:TextFormat = new TextFormat();
		private var greyBar = new GreyBar();
		private var heading = new TextField();
		private var tekst = new TextField();
		public var lengde:int;
		public var maxVal:Number;
		
		public function Bar(barType,lengde:int,header:String,maxVal:Number):void{
			bar = new barType();
			this.lengde = lengde;
			this.maxVal = maxVal;
			
			tekstFormat.font = "_typewriter";
			tekstFormat.size = 16;
			tekstFormat.align = "left";
			tekstFormat.bold = true;
			tekstFormat.color = 0xFFFFFF;
			
			heading.selectable = false;
			heading.text = header;
			heading.height = 20;
			heading.setTextFormat(tekstFormat);
			
			bar.x = heading.width - 2;
			bar.y = 6;
			greyBar.x = bar.x + lengde;
			greyBar.y = bar.y;
			greyBar.alpha = 0.5;
			
			tekstFormat.size = 15;
			tekstFormat.color = 0xFFFF66;
			
			tekst.width = 50;
			tekst.height = 20;
			tekst.selectable = false;
			
			addChild(greyBar);
			addChild(bar);
			addChild(heading);
			addChild(tekst);
			
			update(maxVal);
		}
		
		public function update(val:Number):void{
			bar.scaleX = lengde * (val/maxVal);
			greyBar.scaleX = bar.scaleX - lengde;
			tekst.x = bar.x + bar.scaleX + 1;
			tekst.text = String(Math.ceil((val/maxVal)*100)) + "%";
			tekst.setTextFormat(tekstFormat);
		}

	}
}