package util
{
	public class Validator
	{
		public function Validator()
		{
		}
		
		public static function checkUniqueIDs(mySAN:XML,hashmap:Object):String { //this is not correct ?
			var msg:String = "";
			var result:String = "";
			if (hashmap == null) hashmap = {};
			if (mySAN==null) {
				//Alert.show(hashmap);
				return "";	
			}	
			for each (var node:XML in mySAN.descendants()) {
				trace(node.@id + " -> " + node.@name);
				if (String(node.@id) == "") continue;
				
				if (hashmap[node.@id] == null) 
					hashmap[node.@id] = {id:node.@id,name:node.@name,parent:node.parent.@name};
				else {			
					msg = "Two nodes have the same Ids : Id '" 
						+ node.@id	+ "' found in : '" + node.parent().@name + "." + node.@name 
						+ "' and '" + hashmap[node.@id].parent + "." + hashmap[node.@id].name + "' \n";
					//Alert.show(msg);
					result += msg ;
				}
				//for each (var child:XML in node.children() )  // not needed with descendants = all children + grandchildren ..
				//result += checkUniqueIDs(child,hashmap); 
			}
			return result;
		}

	}
}