package{
	
	import flash.display.*;
	
	public class RawMeat extends Item{
		
		public var label:String = "rawmeat";
		public var type = RawMeat;
		
		
		public function RawMeat():void{
			actions.hunger = 10;
			actions.energy = 5;
		}

		
	}
}