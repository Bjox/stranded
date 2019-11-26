package{
	
	import flash.display.*;
	import flash.text.*;
	
	public class Action extends MovieClip{
		
		public var resultType:Class;
		public var resultAmount:int;
		public var actionType:Class;
		public var tekst:TextField = new TextField();
		public var descTekst:TextField = new TextField();
		private var tekstFormat:TextFormat = new TextFormat();
		public var lPrice:int;
		public var rPrice:int;
		
		public function Action(actionTekst:String, craft:Boolean, resultType:Class ,resultAmount:uint, lPrice:int, rPrice:int, desc:String, actionType:Class, lengde:Number):void{
			
			this.resultType = resultType;
			this.resultAmount = resultAmount;
			this.lPrice = lPrice;
			this.rPrice = rPrice;
			this.actionType = actionType;
			
			tekstFormat.font = "_typewriter";
			tekstFormat.size = 12;
			tekstFormat.align = "center";
			tekstFormat.bold = true;
			if (craft) tekstFormat.color = 0xFFFF00;
			else tekstFormat.color = 0x555555;
			
			tekst.height = 20;
			tekst.width = lengde;
			tekst.text = actionTekst;
			tekst.selectable = false;
			tekst.setTextFormat(tekstFormat);
			
			tekstFormat.size = 20;
			
			descTekst.height = 25;
			descTekst.width = lengde;
			descTekst.y = 10;
			descTekst.text = desc;
			descTekst.selectable = false;
			descTekst.setTextFormat(tekstFormat);
			
			addChild(tekst);
			addChild(descTekst);
		}
	}
}