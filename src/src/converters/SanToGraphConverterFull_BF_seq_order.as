package converters
{
	import mx.controls.Alert;
	
	public class SanToGraphConverterFull
	{
		
		private var gxml:XML; 
		private var cid:int = 0; //global
		private var pid:int = 0; //global
		private var _drawSituationAsNode:Boolean = false;
		private var _drawConditionAsNode:Boolean = false;
		
		/**
		 * SanToGraphConverterFull : draws also situation & condition as nodes
		 **/
		public function SanToGraphConverterFull() 
		{
		}
		
		public function getGraph(sanXML:XML,selectedSANIndex:int,sitAsNode:Boolean,condAsNode:Boolean):XML {
			//init global vars
			//gxml = <Graph><Node id="0" name={sanXML.san[0].@id} desc="SAN"  type="san"
			//	nodeColor="0x00FFFF" nodeClass="earth" nodeIcon="center" nodeSize="20" /></Graph>;
			gxml = <Graph></Graph>;	
			pid = 0; //parent node id
			cid = 0; //current node id	
			this._drawConditionAsNode = condAsNode;
			this._drawSituationAsNode  = sitAsNode;
			
			//start recursive convertion
			for each (var node:XML in sanXML.san[selectedSANIndex].g) {
				trace("root-goal :" +node.@name);
				san2graph(node,pid,0);
			}			
			//Alert.show(gxml);
			trace(gxml);
			return gxml;
		}
		
		private function san2graph(root:XML,parent:int,flow:int):void {	
			trace("s2g: "+root.@id + " :" + this.cid);
			var condName:String;
			var sitName:String;
			
			var newflow:int = flow + 50;			
			this.cid ++;
			var new_goal_cid:int = this.cid; 
			var parent_goal_cid:int = new_goal_cid;
			
			try {
				condName = root.c[0].@name ;
			} catch (e:Error) { 
				condName = "";
			}
			try {
				sitName = root.s[0].@name ;
			} catch (e:Error) { 
				sitName = "";
			}
			
			//Goal
			trace("san2graph: root type is:" + root.localName());
			var lname:String = root.localName();
			switch (lname) {
				case "g":
					gxml.appendChild(getGoal(root.@name,new_goal_cid,sitName,condName,root.@id));
					if (new_goal_cid>1) gxml.appendChild(getEdge(parent,new_goal_cid,"goal",flow));
				break;
				case "d":
					//gxml.appendChild(getGoal(root.@name,new_goal_cid,sitName,condName));
					gxml.appendChild(getDecorator(root.@name,new_goal_cid,root.@type));
					if (new_goal_cid>1) gxml.appendChild(getEdge(parent,new_goal_cid,root.@type,flow));
				break;
				case "a":
					//gxml.appendChild(getGoal(root.@name,new_goal_cid,sitName,condName));
					gxml.appendChild(getAction(root.@name,new_goal_cid,root.@type));
					if (new_goal_cid>1) gxml.appendChild(getEdge(parent,new_goal_cid,root.@type,flow));
				break;
			}
			//gxml.appendChild(getGoal(root.@name,new_goal_cid,sitName,condName));
			//if (new_goal_cid>1) gxml.appendChild(getEdge(parent,new_goal_cid,"goal",flow));
				
			trace(cid+" under "+parent);
			//DRAWS From Right to left the leafs
			//iterate goal actions
			for each (var action:XML in root.a) {
				trace("action->"+action.@name+":"+action.@type);
				if (String(action.@type).length==0) { // do not create empty node
					for each (var goal:XML in action.g) {				
						san2graph(goal,new_goal_cid,newflow);								
					}
					for each (var decor:XML in action.d) {				
						san2graph(decor,new_goal_cid,newflow);								
					}//for each decorator
					for each (var action:XML in action.a) {				
						san2graph(action,new_goal_cid,newflow);								
					}//for each action eg. sequence under parallel
				} else if (String(action.@type).valueOf()=="Action") { // do not create empty node
					for each (var goal:XML in action.g) {				
						san2graph(goal,new_goal_cid,newflow);								
					}
					for each (var decor:XML in action.d) {				
						san2graph(decor,new_goal_cid,newflow);								
					}//for each decorator
					for each (var action:XML in action.a) {				
						san2graph(action,new_goal_cid,newflow);								
					}//for each action eg. sequence under parallel
				}	
				else {
					//insert the action node
					var oldcid:int = new_goal_cid;
					this.cid++; new_goal_cid = this.cid;										
					gxml.appendChild(getAction(action.@name,new_goal_cid,action.@type));
					gxml.appendChild(getEdge(oldcid,new_goal_cid,action.@type,flow));
					for each (var goal:XML in action.g) {				
						san2graph(goal,new_goal_cid,newflow);								
					}//for each goal
					for each (var decor:XML in action.d) {				
						san2graph(decor,new_goal_cid,newflow);								
					}//for each decorator
					for each (var action:XML in action.a) {				
						san2graph(action,new_goal_cid,newflow);								
					}//for each action eg. sequence under parallel
				}//else				
			}//for each action
			
			//Condition
			if (this._drawConditionAsNode)
			if (condName.length > 0) {
				this.cid ++;
				var new_cond_cid:int = this.cid;
				gxml.appendChild(getCondition(condName,new_cond_cid));
				gxml.appendChild(getEdge(parent_goal_cid,new_cond_cid,"Condition",newflow));
				newflow+=50;
			} 
			
			//Situation
			if (this._drawSituationAsNode)
			if (sitName.length > 0) {
				this.cid ++;
				var new_sit_cid:int = this.cid;
				gxml.appendChild(getSituation(sitName,new_sit_cid));
				gxml.appendChild(getEdge(parent_goal_cid,new_sit_cid,"Situation",newflow));
				newflow+=50;
			}
			
			//iterate goal sub-goals
			for each (var goal:XML in root.g) {
				trace("sub-goal->"+goal.@name);
				trace("\tgoal " + goal.@name + " under " + root.@name);
				san2graph(goal,new_goal_cid,newflow);
			}//for each sub-goal
			
			//iterate goal decorators
			for each (var decor:XML in root.d) {
				trace("decor->"+decor.@name+":"+decor.@type);				
				//insert the decorator node
				var oldcid:int = new_goal_cid;
				this.cid++; new_goal_cid = this.cid;										
				gxml.appendChild(getDecorator(decor.@name,new_goal_cid,decor.@type));
				gxml.appendChild(getEdge(oldcid,new_goal_cid,decor.@type,flow));
				for each (var goal:XML in decor.g) {
					trace("\tgoal " + goal.@name + " under " + decor.@name);
					san2graph(goal,new_goal_cid,newflow);								
				}//for each goal
				for each (var decorator:XML in decor.d) {
					trace("\decorator " + decorator.@name + " under " + decor.@name);
					san2graph(decorator,new_goal_cid,newflow);								
				}//for subdecorator
				for each (var action:XML in decor.a) {
					trace("\action " + action.@name + " under " + decor.@name);
					san2graph(action,new_goal_cid,newflow);								
				}//for subdecorator
				
			}//for each decorator
			
			
			
		}
		
		private function getGoal(name:String,id:int,sit_name:String,con_name:String,node_id:String):XML {
			/*
			return XML("<Node id='" +id+"' name='"+name+"' desc='"+name+"_desc' type='goal' " +
				" sitName='"+sit_name+"' conName='"+con_name+"' " +
				"nodeColor='0x110099' nodeSize='25' />");
			*/
			/*
			var ret:String = 
				"<Node id='" +id+"' name='"+name+"' desc='"+name+"_desc' type='goal' " +
				" sitName='"+sit_name+"' conName='"+con_name+"' " +
				"nodeColor='0x110099' nodeSize='25' />";
			trace(ret);
			*/
			//return new XML(ret);
			var x:XML =  
				<Node id={id} name={name} desc='_desc' type='Goal' 
				 sitName={sit_name} conName={con_name} node_id={node_id}
				 nodeColor='0x110099' nodeSize='25' />;
			trace(x);
			return x;
				
		}
		
		private function getCondition(name:String,id:int):XML {
			/*
			return XML("<Node id='" +id+"' name='"+name+"'  " +
				"type='Condition' nodeColor='0xff0099' nodeSize='25' />");
			*/
			return <Node id={id} name={name} 
				type='Condition' nodeColor='0xff0099' nodeSize='25' />;
		}
		
		private function getSituation(name:String,id:int):XML {
			/*
			return XML("<Node id='" +id+"' name='"+name+"'  " +
				"type='Situation' nodeColor='0xff0099' nodeSize='25' />");
			*/
			return <Node id={id} name={name}  
				type='Situation' nodeColor='0xff0099' nodeSize='25' />
		}
		
		private function getAction(name:String,id:int,type:String):XML {
			/*
			return XML("<Node id='" +id+"' name='"+name+"' desc='"+type+"_desc' " +
				" subtype='"+type+"' " +
				"type='action' nodeColor='0xff0099' nodeSize='25' />");
			*/
			return <Node id={id} name={name} desc={type+"_desc"}
				 subtype={type}
				type='Action' nodeColor='0xff0099' nodeSize='25' />;
		}
		
		private function getDecorator(name:String,id:int,type:String):XML {
			/*
			return XML("<Node id='" +id+"' name='"+name+"' desc='"+type+"_desc' " +
				" subtype='"+type+"' " +
				"type='decorator' nodeColor='0xffee00' nodeSize='25' />");
			*/
			return <Node id={id} name={name} desc={type+"_desc"}
				subtype={type}
				type='Decorator' nodeColor='0xffee00' nodeSize='25' />;
		}
		
		private function getEdge(_pid:int,_cid:int,_type:String,_flow:int):XML {
			return XML("<Edge fromID='"+_pid+"' toID='"+_cid+"' edgeLabel='"+_type+"' flow='"+_flow+"' color='black' />");
		}
		
		private function getSitName(g:XML):String {
			var sitName:String ;
			try {
				sitName = g.s[0].@name ;
			} catch (e:Error) { 
				sitName = "";
			}
			return sitName;
			
		}
		private function getCondName(g:XML):String {
			var condName:String ;
			try {
				condName = g.c[0].@name ;
			} catch (e:Error) { 
				condName = "";
			}
			return condName;
		}
		
	}
	
}