package util
{
	import flash.events.*;
	import flash.net.*;
	
	import mx.managers.CursorManager;
	
	public class ExternalConfig
	{
		var xmlLoader:URLLoader = new URLLoader();
		public var configXML:XML;
		var callOnLoad:Function;
		
		public function ExternalConfig(filePath:String,_callOnLoad:Function):void 
		{						
			this.callOnLoad = _callOnLoad; 
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			xmlLoader.load(new URLRequest(filePath));			
		}
		
		function xmlLoaded(e:Event):void
		{
			this.configXML = new XML(e.target.data);
			trace("**ExternlConfig: xmlLoaded");
			trace("**ExternlConfig: \n" + configXML);
			this.callOnLoad(configXML);
		}
	}
}