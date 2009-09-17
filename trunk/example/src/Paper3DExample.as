package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ghostcat.transfer.Paper3D;
	
	public class Paper3DExample extends Sprite
	{
		public var p:Paper3D;
		public function Paper3DExample()
		{
			p = new Paper3D(new TestRepeater());
			p.x = 50;
			p.y = 50;
			addChild(p);
			
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		private function enterFrameHandler(event:Event):void
		{
			p.rotationY++;
		}
	}
}