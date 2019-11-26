package{
	
	import flash.display.*;
	
	public class Meat extends Item{
		
		public var label:String = "meat";
		public var type = Meat;
		
		
		public function Meat():void{
			actions.hunger = 50;
			actions.energy = 25;
		}
		
	}
}