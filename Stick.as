package{
	
	import flash.display.*;
	
	public class Stick extends Item{
		
		public var label:String = "stick";
		public var type = Stick;

		public function Stick():void{
			actions.energy = 0;
			weight = 1;
		}
		
	}
}