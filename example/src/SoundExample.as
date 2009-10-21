package
{
	import flash.events.Event;
	import flash.media.SoundTransform;
	
	import ghostcat.display.GBase;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.SoundOper;
	import ghostcat.operation.TweenOper;
	import ghostcat.operation.WaitOper;
	import ghostcat.operation.WatchOper;
	import ghostcat.ui.containers.GAlert;
	
	[SWF(width="600",height="600")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SoundExample extends GBase
	{
		public function SoundExample()
		{
			RootManager.register(this);
			
			GAlert.show("音乐开始");
			
			var oper:SoundOper = new SoundOper("f8i746.MP3",true,0,1,0);
			oper.addTween(0,1000,1);
			oper.addTween(3000,2000,0,1);
			oper.commit();
			
			GAlert.show("音乐结束");
		}
	}
}