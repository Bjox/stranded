package{
	
	import flash.display.*;
	
	public class WaterCoconut extends Item{
		
		public var label:String = "watercoconut";
		public var type = WaterCoconut;
		
		public function WaterCoconut():void{
			actions.energy = 5;
			actions.hunger = 2;
		}
		

	}
}