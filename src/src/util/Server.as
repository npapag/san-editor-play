package util
{
	public class Server
	{
		public function Server()
		{
		}
		
		public function getNewID():String {
			//server-less work-around
			var date:Date = new Date();			
			return date.getTime().toString();
		}
		
		public function getNewIDWithPrefix(prefix:String):String {
			return prefix + getNewID();
		}
	}
}