package{
	
	public class Chicken extends Mob{
		
		public function Chicken():void{
			hp = 8;
			vel = 2;
			dropItems.push({type:RawMeat, amount:1});
			
		}
		
	}
	
}