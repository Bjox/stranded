package{
	
	import flash.display.*;
	
	public class Match extends Item{
		
		public var label:String = "match";
		public var type = Match;

		public function Match():void{
			actions.energy = 0;
			weight = 1;
		}
		
	}
}