package
{
	import flash.display.Sprite;
	
	import ghostcat.skin.HScrollBarSkin;
	import ghostcat.ui.controls.GNumberic;
	import ghostcat.ui.controls.GNumbericStepper;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var t:GNumbericStepper = new GNumbericStepper();
			t.prefix = "$";
			t.setValue(100);
			t.editable = true;
			addChild(t);
		}
	}
}