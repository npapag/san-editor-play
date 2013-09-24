package util
{
	import mx.core.ByteArrayAsset;
	
	public final class EmbeddedConfig
	{
		[Embed("config/embedded-config.xml", mimeType="application/octet-stream")]
		private static const AppConfig:Class;
		
		public static function getAppConfig() : XML
		{
			var ba:ByteArrayAsset = ByteArrayAsset( new AppConfig() );
			var xml:XML = new XML( ba.readUTFBytes( ba.length ) );
			trace(xml);			
			return xml;    
		}
	}
}