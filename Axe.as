package{
	
	import flash.display.*;
	
	public class Axe extends Item{
		
		public var label:String = "axe";
		public var type = Axe;
		public var multiplier:Number = 5;

		public function Axe():void{
			actions.energy = 0;
			weight = 3;
			tool = true;
		}
		
	}
}