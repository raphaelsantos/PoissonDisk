package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	public class PoissonDiskTest extends Sprite
	{
		public function PoissonDiskTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var poisson:PoissonDisk = new PoissonDisk();
			poisson.minRadius = 3;
			poisson.maxRadius = 30;
			
			poisson.minDistance = 2;
			poisson.spread = 5;
			poisson.maxTries = 5000;
			
			
			
			var poissonArea:Rectangle = new Rectangle(0,0, 550, 400);
			var points:Vector.<PoissonPoint> = poisson.createPoissonPoints(poissonArea, 3000);
			poisson.drawGrid(graphics);
			
			
			
			for each(var point:PoissonPoint in points)
			{
				drawCircle(point);
			}
		}
		
		private function drawCircle(point:PoissonPoint):void
		{
			this.graphics.beginFill(0xFF0000, .3);
			this.graphics.lineStyle(1);
			this.graphics.drawCircle(point.x, point.y, point.radius);
			this.graphics.endFill();
		}
	}
}