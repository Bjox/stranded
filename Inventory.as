package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Mouse;
	
	public class Inventory extends MovieClip{
		
		public var numberOfSlots:int = 8;
		public var slot:Array = new Array();
		public var hidden:Boolean = false;
		public var vel:Number = 0;
		private var xmove:Number = 0;
		public var invbar = new InvBar();
		public var linv = new Linv();
		public var rinv = new Rinv();
		public var lslot = new Slot();
		public var rslot = new Slot();
		public var temp = new TempSlot();
		public var statusVindu = new StatusVindu();
		
		public var weight:uint = 0;
		
		
		public function Inventory(screenSize:int):void{
			this.addEventListener(Event.ENTER_FRAME, loop);
			temp.addEventListener(MouseEvent.CLICK, klikk);
			invbar.x = 32;
			invbar.y = screenSize - invbar.height;
			rinv.x = screenSize - rinv.width;
			rslot.x = rinv.x + (rinv.width/2);
			rslot.y = rslot.height - 3;
			lslot.x = linv.x + (linv.width/2);
			lslot.y = lslot.height - 3;
			statusVindu.y = 486;
			statusVindu.x = 64;
			addChild(invbar);
			addChild(statusVindu);
			addChild(linv);
			addChild(rinv);
			addChild(rslot);
			addChild(lslot);
			addChild(temp);
			for (var i=0; i<numberOfSlots; i++){
				slot[i] = new Slot();
				slot[i].x = 32;
				slot[i].y = (60*i) + invbar.y + 30;
				addChild(slot[i]);
				slot[i].addEventListener(MouseEvent.CLICK, klikk);
				slot[i].slotNr = i;
			}
			slot.push(lslot);
			slot.push(rslot);
			lslot.slotNr = 8;
			rslot.slotNr = 9;
			numberOfSlots += 2;
			rslot.addEventListener(MouseEvent.CLICK, klikk);
			lslot.addEventListener(MouseEvent.CLICK, klikk);
			temp.x = -50;
			temp.y = -50;
		}
		
		
		
		public function additem(type):Boolean{
			var tatt:Boolean = false;
			var a = new type();
			for (var i=0; i<numberOfSlots; i++){
				if (slot[i].type == type && slot[i].amount < slot[i].maxStackSize){
					slot[i].inc(1);
					tatt = true;
					break;
				}
				if (i == numberOfSlots-1){
					for (var u=0; u<numberOfSlots; u++){
						if(slot[u].type == null){
							slot[u].addItemType(type,1);
							tatt = true;
							break;
						}
					}
				}
			}
			if (tatt) updateWeight(type, 1);
			return tatt;
		}
		
		
		
		public function removeitem(type:Class, amount:uint):void{
			if (lslot.type == type){
				lslot.inc(-amount);
			}
			else if (rslot.type == type){
				rslot.inc(-amount);
			}
			updateWeight(type, amount, true);
		}
		
		
		
		public function pay(lAmount:uint, rAmount:uint):void{			
			if (lslot.type != null){
				lslot.inc(-lAmount);
				updateWeight(lslot.type, lAmount, true);
			}
			if (rslot.type != null){
				rslot.inc(-rAmount);
				updateWeight(rslot.type, rAmount, true);
			}
		}
		
		
		
		public function updateWeight(type:Class, amount:uint, subtract:Boolean = false):uint{
			if (type != null){
				for (var i=0; i<amount; i++){
					var a = new type();
					if (subtract) weight -= a.weight;
					else weight += a.weight;
				}
			}
			statusVindu.editWeight(weight);
			return weight;
		}
		
		
		
		private function klikk(evt){
			if (evt.currentTarget != temp) var s = slot[evt.currentTarget.slotNr];
			
			if (temp.activeSlot){
				//Deselect
				for (var i=0; i<numberOfSlots; i++){
					if (temp.mc.hitTestObject(slot[i].slotArea)){
						//Samme type
						if (slot[i].type == temp.type){
							slot[i].inc(temp.amount);
							if (slot[i].amount > 32){
								var rest:int = slot[i].amount - 32;
								slot[i].inc(-rest);
								temp.setAmount(rest);
							}
							else{
								temp.activeSlot = false;
								temp.removeSlot();
							}
						}
						//Tom
						else if (slot[i].type == null){
							slot[i].addItemType(temp.type,temp.amount);
							temp.activeSlot = false;
							temp.removeSlot();
						}
						//Bytte
						else{
							var t = {type:slot[i].type, amount:slot[i].amount};
							slot[i].removeSlot();
							slot[i].addItemType(temp.type,temp.amount);
							temp.removeSlot();
							temp.addItemType(t.type);
							temp.setAmount(t.amount);
						}
						break;
					}
					//Drop
					if (i == numberOfSlots-1){
						dispatchEvent(new Event(Event.CHANGE));
						updateWeight(temp.type, temp.amount, true);
						temp.removeSlot();
						temp.activeSlot = false;
					}
				}
			}
			else{
				if (s.type != null){
					//Select
					if (evt.shiftKey && s.amount > 1){
						temp.addItemType(s.type);
						if (s.amount % 2 != 0){
							s.inc(-1);
							temp.setAmount((s.amount/2+1));
							s.inc(-s.amount/2)
						}
						else{
							temp.setAmount(s.amount/2);
							s.inc(-s.amount/2)
						}
						temp.activeSlot = true;
					}
					else{
						temp.addItemType(s.type);
						temp.setAmount(s.amount);
						temp.activeSlot = true;
						s.removeSlot();
					}
					setChildIndex(temp, numChildren-1);
				}
			}
			
		}
		
		
		
		public function equipped(item1:Class, item2:Class):Boolean{
			var equipped:Boolean;
			if ((rslot.type == item1 && lslot.type == item2) || (rslot.type == item2 && lslot.type == item1)){
				equipped = true;
			}
			else equipped = false;
			
			return equipped;
		}
		
		
		
		public function equippedTool():Class{
			var a:Class = null;
			var item1 = null;
			var item2 = null;
			var eq1:Boolean;
			var eq2:Boolean;
			
			if (lslot.type != null){
				item1 = new lslot.type;
				eq1 = item1.tool;
				item1 = lslot.type;
			}
			if (rslot.type != null){
				item2 = new rslot.type;
				eq2 = item2.tool;
				item2 = rslot.type;
			}
			
			if (eq1 && !eq2) a = item1;
			if (eq2 && !eq1) a = item2;
			
			return a;
		}
		
		
		
		public function toggleInv():void{
			if(hidden){
				hidden = false;
				vel = 4;
			}
			else{
				hidden = true;
				vel = -4;
			}
		}
		
		
		
		private function loop(evt):void{
			x += vel;
			rinv.x -= 2*vel;
			rslot.x -= 2*vel;
			statusVindu.x -= vel/2;
			statusVindu.y -= vel*1.25;
			xmove += vel;
			if (xmove <= -64 && hidden){
				vel = 0;
			}
			if (xmove >= 0 && !hidden){
				vel = 0;
			}
			
			
			
		}
		
	}
}