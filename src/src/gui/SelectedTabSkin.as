package gui
{
	import mx.containers.Canvas;
	
	public class SelectedTabSkin extends Canvas
	{
		override protected function updateDisplayList
			(w : Number, h : Number) : void
		{
			//this.styleName = "selectedTab";
			this.graphics.beginFill(0xFF00FF,1.0);
			super.updateDisplayList (w, h);
		}
		
	}
} 