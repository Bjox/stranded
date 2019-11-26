package
{
	
	import flash.geom.*;
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	public class Window_mc extends MovieClip
	{
		protected var sideU:Side_bm = new Side_bm();
		protected var sideR:Side_bm = new Side_bm();
		protected var sideL:Side_bm = new Side_bm();
		protected var sideD:Side_bm = new Side_bm();
		protected var corner1:Corner_bm = new Corner_bm();
		protected var corner2:Corner_bm = new Corner_bm();
		protected var corner3:Corner_bm = new Corner_bm();
		protected var corner4:Corner_bm = new Corner_bm();
		protected var fill:Fill_bm = new Fill_bm();
		private var tekstFormat:TextFormat = new TextFormat();
		public var actions:Array = new Array();
		public var lengde:Number;
		public var craftedItem = {type:Class, amount:int, lPrice:int, rPrice:int, actionType:Class};
		
		protected var bitMapLengde:uint = 32
		
		public function Window_mc(xPos:Number, yPos:Number, lengde:Number, høyde:Number)
		{
			this.lengde = lengde;
			
			x = xPos;
			y = yPos;
			
			addChild(sideR);
			addChild(sideL);
			addChild(sideU);
			addChild(sideD);
			
			addChild(corner1);
			addChild(corner2);
			addChild(corner3);
			addChild(corner4);
			
			addChild(fill);
			
			//Sette på plass hjørner og rotere dem
			corner2.x = lengde;
			corner2.rotation += 90;
			
			corner3.y = høyde;
			corner3.rotation -= 90;
			
			corner4.x = corner2.x;
			corner4.y = corner3.y;
			corner4.rotation += 180;
			
			//Sette på plass sider, og rotere dem
			sideU.x = bitMapLengde;
			sideU.scaleX =(lengde - (2 * bitMapLengde))/bitMapLengde;
			
			sideD.rotation += 180;
			sideD.x = corner4.x - bitMapLengde;
			sideD.y = corner3.y;
			sideD.scaleX =(lengde - (2 * bitMapLengde))/bitMapLengde;
			
			sideR.rotation += 90;
			sideR.x = corner2.x;
			sideR.y = bitMapLengde;
			sideR.scaleX = (høyde - (2 * bitMapLengde))/bitMapLengde;
			
			sideL.rotation -= 90;
			sideL.y = corner3.y - bitMapLengde;
			sideL.scaleX = (høyde - (2 * bitMapLengde))/bitMapLengde;
			
			//Fylle ut vinduet
			fill.width = sideU.width;
			fill.height = sideR.height;
			fill.x = bitMapLengde;
			fill.y = bitMapLengde;
			
		}
		
		public function addAction(tekst:String, craft:Boolean, resultType:Class, resultAmount:int, lPrice:int, rPrice:int, desc:String, actionType:Class):void{
			alpha = 0.9;
			
			var costTekst:String = tekst;
			if (lPrice == 0 || rPrice == 0) costTekst = "";
			var action = new Action(costTekst,craft,resultType,resultAmount,lPrice,rPrice,desc,actionType,lengde);
			
			action.y = 12 + (actions.length * 40);
			if (craft) action.addEventListener(MouseEvent.CLICK, klikk);
			actions.push(action);
			addChild(action);
			resizeWindow((actions.length*40)+32);
			
		}
		
		public function klikk(evt):void{
			var clicked = evt.currentTarget;
			
			craftedItem.type = clicked.resultType;
			craftedItem.amount = clicked.resultAmount;
			craftedItem.lPrice = clicked.lPrice;
			craftedItem.rPrice = clicked.rPrice;
			craftedItem.actionType = clicked.actionType;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function clearWindow():void{
			for (var i=0; i<actions.length; i++){
				removeChild(actions[i]);
			}
			actions.splice(0,actions.length);
			resizeWindow(64);
			alpha = 0;
		}
		
		public function resizeWindow(høyde:Number):void{
			//Sette på plass hjørner og rotere dem
			corner3.y = høyde;
			corner4.y = corner3.y;
			
			//Sette på plass sider, og rotere det
			sideD.y = corner3.y;

			sideR.scaleX = (høyde - (2 * bitMapLengde))/bitMapLengde;
			
			sideL.y = corner3.y - bitMapLengde;
			sideL.scaleX = (høyde - (2 * bitMapLengde))/bitMapLengde;
			
			//Fylle ut vinduet
			fill.height = sideR.height;
		}
		
		
	}
}