package{
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	public class Slot extends MovieClip{
		
		public var maxStackSize:uint = 32;
		
		public var mc:MovieClip;
		public var type = null;
		public var slotNr:uint;
		public var tekst:TextField = new TextField();
		public var tekstFormat:TextFormat = new TextFormat();
		public var slotArea = new SlotArea();
		public var amount:int = 0;
		public var activeSlot:Boolean = false;
		
		public function Slot():void{
			tekstFormat.font = "_typewriter";
			tekstFormat.size = 18;
			tekstFormat.align = "center";
			tekstFormat.bold = true;
			tekstFormat.color = 0xFFE0B3;
			
			tekst.height = 20;
			tekst.width = 32;
			tekst.selectable = false;
			tekst.y = 4;
			tekst.x = - (tekst.width/2);
			setTekst();
			addChild(slotArea);
			
		}
		
		public function inc(a:int):void{
			amount += a;
			tekst.setTextFormat(tekstFormat);
			setTekst();
			if (amount < 1) removeSlot();
		}
		
		public function setTekst():void{
			if (amount > 1) tekst.text = String(amount);
			else tekst.text = "";
			tekst.setTextFormat(tekstFormat);
		}
		
		public function addItemType(itemType, amount:int):void{
			type = itemType;
			mc = new itemType();
			mc.scaleX = 2;
			mc.scaleY = 2;
			addChild(mc);
			addChild(tekst);
			inc(amount);
			dispatchEvent(new Event(Event.CHANGE));
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
			dispatchEvent(new Event(Event.CHANGE));
		}


	}
}