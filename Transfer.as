package
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.*;
	import flash.events.*;
	
	public class Transfer extends Game{
		
		public function TransferTo(mcStart:Array, mcEnd:Array, entStart:Array, entEnd:Array, endXpos:Number, endYPos:Number){
			for (var i = 0; i < mcStart.length; i++){
				for (var j = 0; j < mcStart[i].length; j++){
					trace(j)
					if (mcStart[i][j] != null) this.parent.removeChild(mcStart[i][j]);
					if (entStart[i][j] != null)this.parent.removeChild(entStart[i][j]);
				}
			}
			for (var k = 0; k < mcEnd.length; k++){
				for (var l = 0; l < mcEnd[k].length; l++){
					trace(l)
					if (mcEnd[k][l] != null){
						this.parent.addChild(mcEnd[k][l]);
						mcEnd[k][l].x = k*32;
						mcEnd[k][l].y = l*32;
					}
					if (entEnd[k][l] != null){
						this.parent.addChild(entEnd[k][l]);
						entEnd[k][l].x = k*32;
						entEnd[k][l].y = l*32;
					}
				}
			}
		}
	}
}