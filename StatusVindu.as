package{
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	public class StatusVindu extends MovieClip{
		
		public var energyBar = new Bar(EnergyBar,400,"Energy:",100);
		public var hungerBar = new Bar(HungerBar,400,"Hunger:",100);
		public var strengthStat = new Stat("Strength:",0x999999);
		public var skillStat = new Stat("Skill:",0x999999);
		public var vitalityStat = new Stat("Vitality:",0xFFCC33);
		public var damageStat = new Stat("Damage:",0xFFCC33);
		public var weightStat = new Stat("Inventory:",0xFFCC33,"Kg");

		public var energy:Number = 100;
		public var hunger:Number = 100;
		public var strength:Number = 10;
		public var skill:Number = 10;
		public var vitality:Number = 10;
		public var dead:Boolean = false;
		
		private var timeTekst:TextField = new TextField();
		private var tekstFormat:TextFormat = new TextFormat();
		
		public function StatusVindu():void{
			energyBar.x = 3;
			energyBar.y = 2;
			
			hungerBar.x = 3;
			hungerBar.y = 20;
			
			strengthStat.x = 3;
			strengthStat.y = 45;
			
			skillStat.x = 3;
			skillStat.y = 65;
			
			vitalityStat.x = 3;
			vitalityStat.y = 85;
			
			damageStat.x = 200;
			damageStat.y = 45;
			
			weightStat.x = 200;
			weightStat.y = 65;
			
			timeTekst.x = 200;
			timeTekst.y = 85;
			timeTekst.width = 300;
			
			tekstFormat.font = "_typewriter";
			tekstFormat.size = 16;
			tekstFormat.align = "left";
			tekstFormat.bold = true;
			tekstFormat.color = 0xFFFFFF;
			
			addChild(energyBar);
			addChild(hungerBar);
			addChild(strengthStat);
			addChild(skillStat);
			addChild(vitalityStat);
			addChild(damageStat);
			addChild(timeTekst);
			addChild(weightStat);
			
			editStrength(0);
			editSkill(0);
			editVitality(0);
			editWeight(0);
			editHunger(0);
		}
		
		public function editTime(val:String):void{
			timeTekst.text = "Elapsed time: " + val;
			timeTekst.setTextFormat(tekstFormat);
		}
		
		public function editEnergy(val:Number):void{
			if (!dead) energy += val;
			if (energy < 0){
				energy = 0;
				dead = true;
				dispatchEvent(new Event(Event.CHANGE));
			}
			if (energy > energyBar.maxVal) energy = energyBar.maxVal;
			energyBar.update(energy);
		}
		
		public function editHunger(val:Number):void{
			hunger += val;
			if (hunger < 0) hunger = 0;
			if (hunger > hungerBar.maxVal) hunger = hungerBar.maxVal;
			hungerBar.update(hunger);
		}
		
		public function editStrength(val:Number):void{
			strength += val;
			if (strength < 0) strength = 0;
			strengthStat.update(strength);
		}
		
		public function editWeight(val:Number):void{
			weightStat.update(val/10);
		}
		
		public function editSkill(val:Number):void{
			skill += val;
			if (skill < 0) skill = 0;
			skillStat.update(skill);
		}
		
		public function editDamage(damage:uint):void{
			damageStat.update(damage);
		}
		
		public function editVitality(val:Number):void{
			vitality += val;
			if (vitality < 3) vitalityStat.updateColor(vitality, 0xB10101);
			if (vitality > 7) vitalityStat.updateColor(vitality, 0x009900);
			if (vitality < 7) vitalityStat.updateColor(vitality, 0xFFCC33);
		}
	}
}