package 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ghostcat.display.graphics.ControlRect;
	import ghostcat.ui.CursorSprite;
	import ghostcat.display.graphics.EditableGraphicsSprite;
	import ghostcat.parse.graphics.GraphicsLineStyle;
	import ghostcat.parse.graphics.GraphicsPath;
	
	[SWF(width="300",height="300")]
	/**
	 * 图形变换例子
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ControlRectExample extends Sprite
	{
		public function ControlRectExample()
		{
			//加入两个控制块
			addChild(new ControlRect(new TestRepeater()))
			addChild(new ControlRect(new TestRepeater45()))
			
			//加入可编辑矢量图
			var path:GraphicsPath = new GraphicsPath([new Point(30,0),[new Point(100,0),new Point(50,50)],new Point(0,100)]);
			var p:EditableGraphicsSprite = new EditableGraphicsSprite([new GraphicsLineStyle(0),path]);
			addChild(p);
			
			//加入鼠标
			addChild(new CursorSprite())
		}
	}
}