package{
	
	public class Turtle extends Mob{
		
		public function Turtle():void{
			hp = 20;
			
			dropItems.push({type:RawMeat, amount:2});
		}
		
	}
	
}