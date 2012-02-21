package
{
	public class PoissonPoint
	{
		
		public var x:Number;
		public var y:Number;
		public var radius:Number;
		
		public function PoissonPoint(x:Number=0, y:Number=0, radius:Number=1)
		{
			this.x = x;
			this.y = y;
			this.radius = radius;
		}
		
		public function toString():String
		{
			return "[PoissonPoint Object] x: " + x + " y: " + y + " radius: " + radius;
		}
	}
}