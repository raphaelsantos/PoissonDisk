package
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;

	public class PoissonDisk
	{

		
		public var minDistance:Number = 5;
		public var maxTries:Number = 30000;
		public var spread:Number = 0;
		
		public var minRadius:Number = 10;
		public var maxRadius:Number = 10;
		
		private var gridCols:int;
		private var gridRows:int;
		
		private var gridCellSize:Number;
		private var grid:Array;

		
		public function PoissonDisk()
		{
			
		}
		
		public function createPoissonPoints(area:Rectangle, maxPoints:Number):Vector.<PoissonPoint>
		{
			
			
			
			gridCellSize = (minDistance+maxRadius)*2;
			grid = [];
			gridCols = Math.ceil(area.width/gridCellSize);
			gridRows = Math.ceil(area.height/gridCellSize);
			for(var i:int = 0; i<= gridCols; i++){
				grid[i] = [];
				for (var j:int = 0; j <= gridRows; j++) 
				{
					grid[i][j] = [];
				}
				
			}
			
			var points:Vector.<PoissonPoint> = new Vector.<PoissonPoint>();
			var processingList:Vector.<PoissonPoint> = new Vector.<PoissonPoint>();
			var tries:Number = 0;
			var firstPoint:PoissonPoint;
			
			
			
			firstPoint = new PoissonPoint( Math.random()*(area.width-area.x) + area.x,
												Math.random()*(area.height-area.y) + area.y,
												Math.random()*(maxRadius - minRadius) + minRadius );
				
			points.push(firstPoint);
			processingList.push(firstPoint);
			gridInsertPoint(firstPoint);
			
			var sourcePoint:PoissonPoint;
			
			
			while( points.length < maxPoints  &&  processingList.length)
			{
				sourcePoint = processingList.shift();
				
				var totalTries:Number = tries;
				
				while((tries - totalTries) < 30 && totalTries<maxTries)
				{
					var radius:Number = Math.random() * (maxRadius-minRadius) + minRadius;
					var newPoint:PoissonPoint = createNeighbourPoint(sourcePoint, radius);
					
					var gridX:int = (newPoint.x - area.x)/gridCellSize;
					var gridY:int = (newPoint.y - area.y)/gridCellSize;
					
					if(!insideBounds(newPoint, area))
					{
						tries++;
						continue;
					}

					
					var nearbyPoints:Vector.<PoissonPoint> = gridGetPoints( gridX, gridY);
					var collided:Boolean = false;
					
					for each(var nearbyP:PoissonPoint in nearbyPoints)
					{
						if( isColliding(nearbyP, newPoint) )
						{
							collided = true;
							tries++;
							break;
						}
					}
					
					if(!collided)
					{
						points[points.length] = newPoint;
						processingList[processingList.length] = newPoint;
						gridInsertPoint(newPoint);
					}
				}
			
			}
			
			//trace("tries:", tries, "maxTries:",maxTries, "pointsCreated: " + points.length);
			return points;
			
		}
		
		private function createNeighbourPoint(sourcePoint:PoissonPoint, newPointRadius:Number):PoissonPoint
		{			
			var rad:Number = Math.random()*Math.PI*2;
			var dist:Number = ( Math.random()*spread +1 ) * ( sourcePoint.radius + newPointRadius + minDistance );
			
			var x:Number = sourcePoint.x + Math.cos(rad)*dist;
			var y:Number = sourcePoint.y + Math.sin(rad)*dist;
			
			return new PoissonPoint(x,y, newPointRadius);
		}

		private function insideBounds(p:PoissonPoint, rect:Rectangle):Boolean
		{
			
			return p.x > rect.x && 
				p.x < ( rect.x + rect.width ) &&
				p.y > rect.y &&
				p.y < (rect.y + rect.height)
		}
		
		private function isColliding(pointA:PoissonPoint, pointB:PoissonPoint):Boolean
		{
			var dx:Number = Math.abs(pointA.x - pointB.x);
			var dy:Number = Math.abs(pointA.y - pointB.y);
			
			var expectedDistance:Number = (minDistance + pointA.radius + pointB.radius);
			var sqrExpDist:Number = expectedDistance*expectedDistance;
			
			return dx*dx + dy*dy < sqrExpDist;
		}
		
		private function gridGetPoints(gridX:int, gridY:int):Vector.<PoissonPoint>
		{
			
			
			var pointsArr:Array = []
			for(var i:int =-1; i<2; i++)
			{
				for(var j:int =-1; j<2; j++)
				{
					var col:Array = grid[gridX+i]
						
					if(!col)continue;
					var pointsInGrid:Array = grid[gridX+i][gridY+j];
					if(pointsInGrid){
						pointsArr = pointsArr.concat(pointsInGrid);
					}
				}	
			}
				
			return Vector.<PoissonPoint>(pointsArr);
		}
		
		private function gridInsertPoint(point:PoissonPoint):void
		{
			var gridX:int = point.x/gridCellSize;
			var gridY:int = point.y/gridCellSize;
			
			var gridPoints:Array = grid[gridX][gridY]
			gridPoints[gridPoints.length] = point;
		}
		
		public function drawGrid(g:Graphics):void
		{
			
			g.lineStyle(1,0);
			
			var i:int;
			
			for(i=0; i<gridCols; i++)
			{
				g.moveTo(i*gridCellSize, 0)
				g.lineTo(i*gridCellSize, gridRows*gridCellSize);
			}
			
			for(i= 0; i<gridRows; i++)
			{
				g.moveTo(0, i*gridCellSize)
				g.lineTo(gridCols*gridCellSize, i*gridCellSize);
			}
				
				
		}
	}
}