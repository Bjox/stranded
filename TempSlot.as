package{
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	public class TempSlot extends MovieClip{
		
		
		public var mc:MovieClip;
		public var type = null;
		public var tekst:TextField = new TextField();
		public var tekstFormat:TextFormat = new TextFormat();
		public var amount:int = 0;
		public var activeSlot:Boolean = false;
		
		public function TempSlot():void{
			this.addEventListener(Event.ENTER_FRAME, frame);
			tekstFormat.font = "_typewriter";
			tekstFormat.size = 18;
			tekstFormat.align = "center";
			tekstFormat.bold = true;
			tekstFormat.color = 0xFFE0B3;
			
			tekst.height = 20;
			tekst.width = 32;
			tekst.y = 4;
			tekst.x = - (tekst.width/2);
			tekst.selectable = false;
			setTekst();
			
		}
		
		public function setTekst():void{
			if (amount > 1) tekst.text = String(amount);
			else tekst.text = "";
			tekst.setTextFormat(tekstFormat);
		}
		
		public function setAmount(a:int):void{
			amount = a;
			setTekst();
		}
		
		public function addItemType(itemType):void{
			type = itemType;
			mc = new itemType();
			mc.scaleX = 2;
			mc.scaleY = 2;
			addChild(mc);
			addChild(tekst);
			setAmount(1);
		}
		
		public function removeSlot():void{
			type = null;
			amount = 0;
			tekst.y = 4;
			tekst.x = - (tekst.width/2);
			mc.x = 0;
			mc.y = 0;
			removeChild(mc);
			removeChild(tekst);
		}
		
		public function frame(evt):void{
			if (activeSlot){
				mc.x = mouseX;
				mc.y = mouseY;
				tekst.x = mouseX - (tekst.width/2);
				tekst.y = mouseY + 4;
			}
		}
		
		

	}
}