package util
{
	
	public class Util
	{
				
		public static const actionList:XML = 
			<XMLList>										
				<Action name="Action" value="empty"/>
				<Action name="Sequence" value="Sequence"/>
				<Action name="ParallelAny" value="ParallelAny"/>
				<Action name="ParallelAll" value="ParallelAll"/>										
				<Action name="Selector" value="Selector"/>
				<Action name="Primitive" value="Primitive"/>
				<Action name="Abstract" value="Abstract"/>
				<Action name="Calculation" value="Calculation"/>
				<Action name="Mount" value="Mount"/>													
			</XMLList>;
		
		public static const decorList:XML = 
			<XMLList>										
				<Decor name="Select" value="empty"/>
				<Decor name="Break" value="Break"/>
				<Decor name="Counter" value="Counter"/>
				<Decor name="Condition" value="Condition"/>
				<Decor name="ExceptionHandler" value="ExceptionHandler"/>
				<Decor name="Failure" value="Failure"/>
				<Decor name="Loop" value="Loop"/>				
				<Decor name="Print" value="Print"/>				
				<Decor name="Success" value="Success"/>
				<Decor name="Timer" value="Timer"/>								
			</XMLList>;
		
		//public static var smethodList:XML = null;
			/* not here , TODO: move in config/app-static-data.xml
			<XMLList>										
				<SMethod name="Select" value="empty"/>
				<SMethod name="LOWA" value="LOWA"/>												
				<SMethod name="SMART" value="SMART"/>
			</XMLList>;
			*/
		
		//[Embed(source="config/SelectionMethods.xml", mimeType="application/octet-stream")]
		//[Embed(source="config/SelectionMethods.xml")]
		//public static const SelectionMethods:Class;
		
		
		public static const contextList:XML = 
			<XMLList>
				<Context name="Local" value="local"/>
				<Context name="Global" value="global"/>
				<Context name="Entity" value="entity"/>								
			</XMLList>;
		
		public function Util()
		{
			trace("class Util");
		}
		
		public static function getIDFromName(name:String):String {
			return   "_"+name. replace(/ /g,"_").replace("'","");			
		}
		
		
	}
}