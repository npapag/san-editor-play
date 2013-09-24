package converters
{
	import mx.controls.Alert;
	
	public class SanToGraphConverterSimple
	{
		
		private var gxml:XML; 
		private var cid:int = 0; //global
		private var pid:int = 0; //global
		
		public function SanToGraphConverterSimple()
		{
		}
		
		public function getGraph(sanXML:XML):XML {
			//init global vars
			gxml = <Graph><Node id="0" name={sanXML.san[0].@id} desc="SAN"  type="san"
				nodeColor="0x00FFFF" nodeClass="earth" nodeIcon="center" nodeSize="20" /></Graph>;			
			pid = 0; //parent node id
			cid = 0; //current node id			
			//start recursive convertion
			for each (var node:XML in sanXML.san[0].g) {
				trace("root-goal :" +node.@name);
				san2graph(node,pid,0);
			}			
			//Alert.show(gxml);
			trace(gxml);
			return gxml;
		}
		
		private function san2graph(root:XML,parent:int,flow:int):void {	
			trace("s2g: "+root.@id + " :" + this.cid);
			var newflow:int = flow + 50;
			this.cid ++;
			var newcid:int = this.cid; 
			
			gxml.appendChild(getGoal(root.@name,this.cid,root.s[0].@name,root.c[0].@name));
			gxml.appendChild(getEdge(parent,this.cid,"goal",flow));			
			trace(cid+" under "+parent);
			
			//iterate goal actions
			for each (var action:XML in root.a) {
				trace("action->"+action.@name+":"+action.@type);
				if (String(action.@type).length==0) {
					for each (var goal:XML in action.g) {				
						san2graph(goal,newcid,newflow);								
					}	
				} else {
					//insert the actio node
					var oldcid:int = this.cid;
					this.cid++; newcid = this.cid;										
					gxml.appendChild(getAction(action.@name,newcid,action.@type));
					gxml.appendChild(getEdge(oldcid,newcid,action.@type,flow));
					for each (var goal:XML in action.g) {				
						san2graph(goal,newcid,newflow);								
					}//for each goal					
				}//else				
			}//for each action
			//iterate goal decorators
			for each (var decor:XML in root.d) {
				trace("decor->"+decor.@name+":"+decor.@type);				
				//insert the decorator node
				var oldcid:int = this.cid;
				this.cid++; newcid = this.cid;										
				gxml.appendChild(getDecorator(decor.@name,newcid,decor.@type));
				gxml.appendChild(getEdge(oldcid,newcid,decor.@type,flow));
				for each (var goal:XML in decor.g) {				
					san2graph(goal,newcid,newflow);								
				}//for each goal					
				
			}//for each action
			
		}
		
		private function getGoal(name:String,id:int,sit_name:String,con_name:String):XML {
			return XML("<Node id='" +id+"' name='"+name+"' desc='"+name+"_desc' type='goal' " +
				" sitName='"+sit_name+"' conName='"+con_name+"' " +
				"nodeColor='0x110099' nodeSize='25' />");
		}
		
		private function getAction(name:String,id:int,type:String):XML {
			return XML("<Node id='" +id+"' name='"+name+"' desc='"+type+"_desc' " +
				" subtype='"+type+"' " +
				"type='action' nodeColor='0xff0099' nodeSize='25' />");
		}
		
		private function getDecorator(name:String,id:int,type:String):XML {
			return XML("<Node id='" +id+"' name='"+name+"' desc='"+type+"_desc' " +
				" subtype='"+type+"' " +
				"type='decorator' nodeColor='0xffee00' nodeSize='25' />");
		}
		
		private function getEdge(_pid:int,_cid:int,_type:String,_flow:int):XML {
			return XML("<Edge fromID='"+_pid+"' toID='"+_cid+"' edgeLabel='"+_type+"' flow='"+_flow+"' color='black' />");
		}
		
	}
	
}