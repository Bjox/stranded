package
{
	import flash.display.*;
	import flash.geom.*;
	
	public class PauseScreen
	{
		public var statusWindow:Window_mc;
		
		public function PauseScreen()
		{
			statusWindow = new Window_mc(0, 0, 75, 480);
			return statusWindow;
		}
	}
}