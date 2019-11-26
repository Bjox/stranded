package{
	
	import flash.display.*;
	
	public class Apple extends Item{
		
		public var label:String = "apple";
		public var type = Apple;
		
		public function Apple():void{
			actions.hunger = 20;
			actions.energy = 10;
		}

	}
}