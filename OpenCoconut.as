package{
	
	import flash.display.*;
	
	public class OpenCoconut extends Item{
		
		public var label:String = "opencoconut";
		public var type = OpenCoconut;
		
		public function OpenCoconut():void{
			actions.energy = 10;
			actions.hunger = 3;
		}

	}
}