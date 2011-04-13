package ghostcat.game.item
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import ghostcat.display.bitmap.IBitmapDataDrawer;
	import ghostcat.game.item.collision.ICollision;
	import ghostcat.game.layer.collision.client.ICollisionClient;
	import ghostcat.game.item.sort.ISortCalculater;
	import ghostcat.game.item.sort.SortYCalculater;
	import ghostcat.game.layer.camera.ICamera;

	public class BitmapGameItem extends Bitmap implements ICollisionClient,IBitmapDataDrawer
	{
		/**
		 * 设置了摄像机后，会自动调用其refreshItem方法
		 */
		public var camera:ICamera;
		/**
		 * 设置了排序器后，会自动计算排序深度，并赋值给priority
		 */
		public var sortCalculater:ISortCalculater;
		/**
		 * 排序深度 
		 */
		public var priority:Number;
		
		private var _oldX:Number;
		private var _oldY:Number;
		
		private var _x:Number;
		private var _y:Number;
		
		private var _collision:ICollision;
		public function get collision():ICollision
		{
			return _collision;
		}
		
		public var regX:Number = 0.0;
		public var regY:Number = 0.0;
		
		public override function set x(v:Number):void
		{	
			if (_x == v)
				return;
			
			_oldX = _x;
			_x = v;
			super.x = v - regX;
			
			updatePosition();
		}
		
		public override function set y(v:Number):void
		{
			if (_y == v)
				return;
			
			_oldY = _y;
			_y = v;
			super.y = v - regY;
			
			updatePosition();
		}
		
		public function setPosition(x:Number,y:Number,updatePos:Boolean = true):void
		{
			if (this.x == x && this.y == y)
				return;
			
			_oldX = _x;
			_oldY = _y;
			_x = x;
			_y = y;
			super.x = x - regX;
			super.y = y - regY;
						
			if (updatePos)
				updatePosition();
		}
		
		protected function updatePosition():void
		{
			if (sortCalculater)
				priority = sortCalculater.calculate();
		
			if (camera)
				camera.refreshItem(this);
		}
		
		public override function get x():Number
		{
			return _x;
		}
		
		public override function get y():Number
		{
			return _y;
		}
		
		public function get oldX():Number
		{
			return _oldX;
		}
		
		public function get oldY():Number
		{
			return _oldY;
		}
		
		public function BitmapGameItem(bitmapData:BitmapData) 
		{
			super(bitmapData);
			updatePosition();
		}
		
		/** @inheritDoc*/
		public function drawToBitmapData(target:BitmapData,offest:Point):void
		{
			if (bitmapData)
				target.copyPixels(bitmapData,bitmapData.rect,new Point(_x - regX + offest.x,_y - regY + offest.y),null,null,bitmapData.transparent);
		}		
		
		/** @inheritDoc*/
		public function getBitmapUnderMouse(mouseX:Number,mouseY:Number):Array
		{
			return (uint(bitmapData.getPixel32(mouseX - x - regX,mouseY - y - regY) >> 24) > 0) ? [this] : null;
		}
	}
}