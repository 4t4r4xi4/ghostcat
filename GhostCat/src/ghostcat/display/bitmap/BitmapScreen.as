package ghostcat.display.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.display.GNoScale;
	import ghostcat.util.Util;
	import ghostcat.util.display.MatrixUtil;
	
	/**
	 * 位图高速缓存，适用于同屏大量活动对象的情景
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapScreen extends GNoScale
	{
		/**
		 * FLASH默认渲染，对比组
		 */
		public static const MODE_SPRITE:String = "sprite";
		/**
		 * 采用copyPixel处理
		 */
		public static const MODE_BITMAP:String = "bitmap";
		/**
		 * 采用beginBitmapFill处理
		 */
		public static const MODE_SHAPE:String = "shape";
		
		private var _alphaMultiplier:Boolean;
		
		private var _mode:String = MODE_BITMAP;
		
		public function get mode():String
		{
			return _mode;
		}
		
		public function set mode(value:String):void
		{
			if (content is Bitmap)
				(content as Bitmap).bitmapData.dispose();
			
			_mode = value;
			switch (value)
			{
				case MODE_SPRITE:
					setContent(new Sprite());
					break;
				case MODE_BITMAP:
					setContent(new Bitmap(new BitmapData(width,height,transparent,backgroundColor)));
					break;
				case MODE_SHAPE:
					setContent(new Shape());
					break;
			}
		}
		
		/**
		 * 背景色
		 */
		public var backgroundColor:uint;
		
		/**
		 * 是否使用透明通道
		 */
		public var transparent:Boolean;
		
		/**
		 * 是否每次重绘（每次重绘将会忽略所有特效）
		 */
		public var redraw:Boolean = true;
		
		/**
		 * 需要应用的物品
		 */
		public var children:Array = [];
		
		/**
		 * 物品绘制时附加的颜色
		 */
		public var itemColorTransform:ColorTransform;
		
		/**
		 * 
		 * @param width
		 * @param height
		 * @param transparent	是否使用透明通道
		 * @param backgroundColor	背景色
		 * 
		 */

		public function BitmapScreen(width:Number,height:Number,transparent:Boolean = true,backgroundColor:uint = 0xFFFFFF):void
		{
			super();
			
			this.backgroundColor = backgroundColor;
			this.transparent = transparent;
			this.width = width;
			this.height = height;
			
			this.mode = MODE_BITMAP;
			this.enabledTick = true;
		}
		
		/**
		 * 添加
		 * @param obj
		 * 
		 */
		public function addObject(obj:*):void
		{
			children.push(obj);
		}
		
		/**
		 * 删除 
		 * @param obj
		 * 
		 */
		public function removeObject(obj:*):void
		{
			Util.remove(children,obj);
		}
		
		/** @inheritDoc*/
		protected override function updateSize() : void
		{
			super.updateSize();
			if (mode == MODE_BITMAP)
			{
				var newBitmapData:BitmapData = new BitmapData(width,height,transparent,backgroundColor);
				var bitmapData:BitmapData = (content as Bitmap).bitmapData;
				if (bitmapData)
				{
					newBitmapData.copyPixels(bitmapData,bitmapData.rect,new Point());
					bitmapData.dispose();
				}
				(content as Bitmap).bitmapData = newBitmapData;
			}
		}
		
		/** @inheritDoc*/
		protected override function updateDisplayList() : void
		{
			if (mode == MODE_BITMAP)
			{
				var bitmapData:BitmapData = (content as Bitmap).bitmapData;
				
				if (redraw)
					bitmapData.fillRect(bitmapData.rect,backgroundColor)
				
				bitmapData.lock();
				for each (var obj:* in children)
					drawChild(obj);
				
				bitmapData.unlock();
			}
			else if (mode == MODE_SHAPE)
			{
				if (redraw)
					(content as Shape).graphics.clear();
				
				for each (obj in children)
					drawChild(obj);		
			}
			else if (mode == MODE_SPRITE)
			{
				for each (obj in children)
					drawChild(obj);	
			}
			
			super.updateDisplayList();
		}
		
		/**
		 * 绘制物品
		 * @param obj
		 * 
		 */
		protected function drawChild(obj:*):void
		{
			var source:BitmapData;
			var m:Matrix;
			if (mode == MODE_BITMAP)
			{
				var bitmapData:BitmapData = (content as Bitmap).bitmapData;
				if (obj is IBitmapDataDrawer)
					(obj as IBitmapDataDrawer).drawToBitmapData(bitmapData);
				else if (obj is DisplayObject)
				{
					m = MatrixUtil.getMatrixBetween(obj as DisplayObject,this,this.parent);
					bitmapData.draw(obj as DisplayObject,m,itemColorTransform);
				}
			}
			else if (mode == MODE_SHAPE)
			{
				if (obj is IBitmapDataDrawer)
					(obj as IBitmapDataDrawer).drawToShape((content as Shape).graphics);
			}
			else if (mode == MODE_SPRITE)
			{
				if (obj is DisplayObject && (obj as DisplayObject).stage == null)
					(content as Sprite).addChild(obj as DisplayObject);
			}
		}
		
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			if (content is Bitmap)
			{
				(content as Bitmap).bitmapData.dispose();
				removeChild(content);
			}
			super.destory();
		}
	}
}