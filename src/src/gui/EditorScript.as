import converters.SanToRdfConverter;

import mx.containers.ViewStack;
import mx.controls.Alert;
import mx.core.DragSource;
import mx.events.*;
import mx.events.ItemClickEvent;
import mx.managers.DragManager;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;

import trees.SANTreeDescriptor;
import trees.SANTreeItemRenderer;

[Bindable] private var entsanXMLList:XMLList;
[Bindable] private var entsanXML:XML;

[Bindable] private var sanXMLList:XMLList;
[Bindable] private var sanXML:XML;

[Bindable] private var selectedSANIndex:int = -1;

[Bindable]
[Embed("assets/a2.png")]
private var actIcon:Class;
[Bindable]
[Embed("assets/c2.png")]
private var ctxIcon:Class;
[Bindable]
[Embed("assets/s2.png")]
private var sitIcon:Class;
[Bindable]
[Embed("assets/d16.png")]
private var decIcon:Class;
[Bindable]
[Embed("assets/g16.png")]
private var goaIcon:Class;

private var targetItem:XMLList = null; 
private var c:converters.SanToRdfConverter = new converters.SanToRdfConverter();

/**
 * on creation complete : init
 * */

private function init():void {
	
	/* moved to onLoadFile
	//this.sanXML = new XML(this.xmlSAN);
	this.sanXMLList = null;
	//(cpatTree as Tree).invalidateDisplayList();
	//this.sanXMLList = new XMLList(alistXML.solution[0].cpat[0].actionlist[0]); //data provider of cpatTree
	this.sanXMLList = new XMLList(sanXML.san[0]);
	//Alert.show(sanXML.g[0]);
	//trace("\n on_getCPatSolution\n" + alistXMLList + "\n");
	(treeSAN as Tree).invalidateDisplayList();		
	(treeSAN as Tree).enabled = true;
	*/
	
	/*
	var sans:XML = <XMLList>
	<Node name="SAN FILE 1" value="100"/>
	<Node name="SAN FILE 2" value="200"/>
	</XMLList>;												
	cmbSANs.dataProvider =sans.Node;						
	cmbSANs.labelField = "@name";
	*/
	
	var actions:XML = <XMLList>
					<Action name="SubGoal" value="SubGoal"/>
					<Action name="Sequence" value="Sequence"/>
					<Action name="ParallelAny" value="ParallelAny"/>
					<Action name="ParallelAll" value="ParallelAll"/>										
					<Action name="Selector" value="Selector"/>
					<Action name="Primitive" value="Primitive"/>
					<Action name="Abstract" value="Abstract"/>
					<Action name="Calculation" value="Calculation"/>
					<Action name="Mount" value="Mount"/>
		</XMLList>;
	cmbGoalActions.dataProvider = actions.Action;						
	cmbGoalActions.labelField = "@name";
	
	var decorators:XML = <XMLList>
							<Node name="Break" value="Break"/>
							<Node name="Counter" value="Counter"/>
							<Node name="Condition" value="Condition"/>
							<Node name="ExceptionHandler" value="ExceptionHandler"/>
							<Node name="Failure" value="Failure"/>
							<Node name="Loop" value="Loop"/>
							<Node name="Timer" value="Timer"/>
							<Node name="Print" value="Print"/>							
							<Node name="Success" value="Success"/>							
						</XMLList>;
	cmbDecoratorActions.dataProvider = decorators.Node;						
	cmbDecoratorActions.labelField = "@name";
	
	currentState = 'showNothing';
	//currentState = 'showGoal';
	//this.windowshade0.opened = false;
	//this.windowshade1.opened = false;
	
	//this.btItemUpdate.addEventListener(MouseEvent.CLICK,onUpdateItem);
	this.btItemDelete.addEventListener(MouseEvent.CLICK,onDeleteItem);
	this.btSetGoalAction.addEventListener(MouseEvent.CLICK,onSetGoalAction);
	this.btAddDecorator.addEventListener(MouseEvent.CLICK,onAddDecorator);				
	this.btAddCondition.addEventListener(MouseEvent.CLICK,onAddCondition);
	this.btAddSituation.addEventListener(MouseEvent.CLICK,onAddSituation);
	this.btNewRootGoal.addEventListener(MouseEvent.CLICK,onNewRootGoal);
	this.btAddAction..addEventListener(MouseEvent.CLICK,onAddAction);
	
	this.btSANLoad.addEventListener(MouseEvent.CLICK,onLoadFileClick);
	this.btSANSave.addEventListener(MouseEvent.CLICK,onBeginSANFileSave);
	this.btSANExport.addEventListener(MouseEvent.CLICK,onSANExport);
	
	this.btSANPreviewN3.addEventListener(MouseEvent.CLICK,onSANExportN3);
	
	this.btSANNew.addEventListener(MouseEvent.CLICK,onNewFile);
	
	this.btAddAPool.addEventListener(MouseEvent.CLICK,onAddActionPool);
	this.btAddSAN.addEventListener(MouseEvent.CLICK,onAddSAN);
	this.btAddEntity.addEventListener(MouseEvent.CLICK,onAddEntity);
	this.btDeleteEntityItem.addEventListener(MouseEvent.CLICK,onDeleteEntityItem);
	
	this.wShadeMetaDataEditor.tabChildren = false;
}

/**
 *
 * Event Handlers   
 *
 **/
private function onAddActionPool(e:Event):void {
	trace("onAddActionPool");
	var item:XML = (this.treeEntities as Tree).selectedItem as XML;
	if (item==null) {
		Alert.show("Please select an entity"); return;
	} else if (item.localName()!="entity"){
		Alert.show("Please select an entity"); return;
	} else {
		var xml:XML = 
			<apool id="newapool1" name="New Action Pool">
					<sans>
					</sans>			
				</apool>;
		this.entsanXML..entity.(@id==item.@id).appendChild(xml);
	}
}

private function onAddSAN(e:Event):void {
	trace("onAddSAN");
	var item:XML = (this.treeEntities as Tree).selectedItem as XML;
	if (item==null) {
		Alert.show("Please select a 'sans' node"); return;
	} else if (item.localName()!="sans"){
		Alert.show("Please select a 'sans' node"); return;
	} else {
		var xml:XML = 
			<san id="-new-san1" name="san-name" base="http://play/sans/template-san-1">
						<g name="new goal" id="_ng1">				
							<s name="new situation" id="_news1" dialect="EP-SPARQL" definedBy="" />
							<c name="new condition" id="_newc1" dialect="SPARQL" definedBy="" />
							<a id="_newa1">
							</a>
						</g>
					</san>;
		trace(item.parent().localName());
		if (item.parent().localName() == "entity") {
			this.entsanXML..entity.(@id==item.parent().@id).sans.appendChild(xml);
		}
		else if (item.parent().localName() == "apool") {
			this.entsanXML..apool.(@id==item.parent().@id).sans.appendChild(xml);
			//item.children().
		}
	}
}
private function onAddEntity(e:Event):void {
	trace("onAddEntity");	
	var xml:XML = <entity name="Entity Name" id="_newentityID"><context></context><sans></sans></entity> ;
	this.entsanXML.appendChild(xml);
}

private function onDeleteEntityItem(e:Event):void {
	trace("onDeleteEntityItem");	 
	var item:XML = (this.treeEntities as Tree).selectedItem as XML;
	switch (item.localName()) {
		case "sans":
		case "context":
			Alert.show("Cannot delete this item. Please select a child item.");
			return;
	}
	if (item!=null) {		                	            
		var children:XMLList = XMLList(item.parent()).children();
		for(var i:Number=0; i < children.length(); i++) {
			if( children[i].@id == item.@id ) {
				delete children[i];            	
			}
		}//for
	}//if
}


private function onAddDecorator(e:Event):void {
	var newXML:XML = null;
	var node:XML = null;				
	var itemXML:XML = (this.cmbDecoratorActions as ComboBox).selectedItem as XML;
	var decType:String = (this.cmbDecoratorActions as ComboBox).selectedItem.@name ;
	
	var type:String = itemXML.@name ;
	node = (this.treeSAN.selectedItem as XML);
	var target_id:String = String(node.@id);
	
	if (node.localName()=="a")
		targetItem = sanXML.san..a.(@id == target_id ) ;
	else if (node.localName()=="d")
		targetItem = sanXML.san..d.(@id == target_id ) ;
	else if (node.localName()=="g")
		targetItem = sanXML.san..g.(@id == target_id ) ;
	else {
		Alert.show("Error : item with id= "+target_id+" not found.");
		return;
	}
	
	newXML = 
		<d name='insert decorator name' 
			type={decType} 
	id={"_decor"+this.getTimeStamp()}>
	<a id={"_act"+this.getTimeStamp()}></a>
	</d>;
	
	//newXML.d.@type = type;
	targetItem.appendChild(newXML);
	treeSAN.expandItem(this.treeSAN.selectedItem,true);
}

private function onAddCondition(e:Event):void {
	var newXML:XML = null;
	var node:XML = (this.treeSAN.selectedItem as XML);
	var target_id:String = String(node.@id);								
	targetItem = sanXML.san..g.(@id == target_id ) ;				
	if (targetItem == null) {
		Alert.show("NOT IMPLEMENTED");
		return;
	}
	newXML = 
		<c 	name='insert condition name' 
			id={"_cond"+this.getTimeStamp()} 
	dialect={"default"} definedBy={"true"} >						
</c>;								 
	targetItem.appendChild(newXML);
}

private function onAddSituation(e:Event):void {
	var newXML:XML = null;
	var node:XML = (this.treeSAN.selectedItem as XML);
	var target_id:String = String(node.@id);								
	targetItem = sanXML.san..g.(@id == target_id ) ;				
	if (targetItem == null) {
		Alert.show("NOT IMPLEMENTED");
		return;
	}
	newXML = 
		<s name='insert situation name' id={"_sit"+this.getTimeStamp()}
	dialect={"default"} definedBy={"true"} 
	>						
</s>;								 
	targetItem.appendChild(newXML);	
}


private function onDeleteItem(e:Event):void {							
	if (this.treeSAN.selectedItem!=null) {
		var node:XML = XML(treeSAN.selectedItem);
		if( node == null ) return;                	            
		var children:XMLList = XMLList(node.parent()).children();
		for(var i:Number=0; i < children.length(); i++) {
			if( children[i].@id == node.@id ) {
				delete children[i];            	
			}
		}//for
	}//if
}

private function onNewRootGoal(e:Event):void {
	var newxml:XML = getNewRootGoal();		
	this.sanXML.san[0].appendChild(newxml);
}

private function onAddAction(e:Event):void {
	var target_id:String = 
		String((this.treeSAN.selectedItem as XML).@id);	
	var newxml:XML =  
		<a name='insert action name' type="" id={"_action"+this.getTimeStamp()}>							
		</a>;
	targetItem = sanXML.san..g.(@id == target_id ) ;
	if (targetItem!=null)
		
		targetItem.appendChild(newxml);
}

private function onSetGoalAction(e:Event):void {
	//Alert.show((this.cmbGoalActions as ComboBox).selectedItem.@name);
	var type:String = (this.cmbGoalActions as ComboBox).selectedItem.@name ;
	//var _as_child:Boolean = true;
	var target_id:String = 
		String((this.treeSAN.selectedItem as XML).@id);
	trace("treeSAN.selectedItem");trace(treeSAN.selectedItem as XML);
	trace("target_id");trace(target_id);
	var newxml:XML = null;
	var lname = (this.treeSAN.selectedItem as XML).localName();
	switch (lname) {
		case "a":
			this.targetItem = sanXML.san[selectedSANIndex]..a.(@id == target_id ) ;
			break;
		case "d":
			this.targetItem = sanXML.san[selectedSANIndex]..d.(@id == target_id ) ;
			break;
		case "g":
			this.targetItem = sanXML.san[selectedSANIndex]..g.(@id == target_id ).a ;
			break;
		default:
			this.targetItem = null;
	}
	trace("--- targetItem ---");
	trace(new XML(targetItem).toXMLString());
	
	if (targetItem == null) {
		Alert.show("NOT SUPPORTED YET");
		return;
	}
	
	trace("--- targetItem ---");
	trace(targetItem);
	
	switch (type) {
		case "SubGoal" :
			newxml = getNewGoal(); 			
			targetItem.appendChild(newxml);			
			break;
		case "Sequence" :
			newxml = getNewGoal();
			targetItem.@type = "Sequence";
			targetItem.appendChild(newxml);
			break;
		case "ParallelAny" :
			newxml = getNewGoal();
			targetItem.@type = "ParallelAny";
			targetItem.appendChild(newxml);
			break;
		case "ParallelAll" :
			newxml = getNewGoal();
			targetItem.@type = "ParallelAll";
			targetItem.appendChild(newxml);
			break;
		case "Selector" :
			newxml = getNewGoal();
			targetItem.@type = "Selector";
			targetItem.appendChild(newxml);
			break;
		case "Abstract" :
			newxml = 
			<a name='insert action name' type="Abstract" id={"_apool"+this.getTimeStamp()}>							
			</a>;
			//targetItem.@type = "ParallelAny";
			targetItem.appendChild(newxml);
			break;
		case "Primitive" :
			newxml = 
			<a name='insert action name' type="Primitive" id={"_apool"+this.getTimeStamp()}>							
			</a>;
			//targetItem.@type = "ParallelAny";
			targetItem.appendChild(newxml);
			break;
		case "Calculation" :
			newxml = 
			<a name='insert action name' type="Calculation" id={"_apool"+this.getTimeStamp()}>							
			</a>;
			//targetItem.@type = "ParallelAny";
			targetItem.appendChild(newxml);
			break;
		case "Simple Action" :
			newxml = 
			<a name='insert action name' type="" id={"_action"+this.getTimeStamp()}>							
			</a>;
			//targetItem.@type = "ParallelAny";
			targetItem.appendChild(newxml);
			break;
	}
	if (newxml==null) {
		Alert.show("Not implemented yet");
		return;
	} else {
		treeSAN.expandItem(this.treeSAN.selectedItem,true);
	}																								
}

private function getNewGoal():XML {
	var newgoal:XML =
		<g name='insert goal name' id={"_goal"+this.getTimeStamp()} autostart="yes" type="normal" >
			<s name="situation-name" id={"_sit"+this.getTimeStamp()} dialect={"default"} definedBy={"true"} ></s>
			<c name="condition-name" id={"_ctx"+this.getTimeStamp()} dialect={"default"} definedBy={"true"}></c>
			<a name="action-name"    id={"_act"+this.getTimeStamp()}></a>
		</g>;
	return newgoal;
}

private function getNewRootGoal():XML {
	var newgoal:XML =
		<g name='insert goal name' id={"_goal"+this.getTimeStamp()} autostart="yes" type="root" >
			<s id={"_sit"+this.getTimeStamp()} dialect={"default"} definedBy={"true"} ></s>
			<c id={"_ctx"+this.getTimeStamp()} dialect={"default"} definedBy={"true"}></c>
			<a id={"_act"+this.getTimeStamp()}></a>
		</g>;
	return newgoal;
}

private function previewSAN():void {
	sanTreeViewerEmbeded.renderSAN(this.sanXML,selectedSANIndex,true,true);
	(this.tabSANEditView).selectedIndex = 1;				
}

private function onEntityTreeChange():void {
	if (this.treeEntities.selectedItem==null) return;
	this.ribbonTabNav.selectedIndex = 1;
	
	trace(treeEntities.selectedItem.localName());
	trace(treeEntities.selectedItem.parent().localName());
	
	switch (treeEntities.selectedItem.localName()) {		
		case "san":
			var san_id:String = treeEntities.selectedItem.@id;
			var san_no:int = 0;
			if (treeEntities.selectedItem.parent().parent().localName()=="entity") {
				var entity_id:String = treeEntities.selectedItem.parent().parent().@id;				
				trace("entity_id="+entity_id+" san_id="+san_id);
				//find the number of the san						
				var nodes = treeEntities.selectedItem.parent().children();
				trace("entity parent item = " +treeEntities.selectedItem.parent().localName());
				trace(nodes);
				if( nodes == null ) return;
				for(var i:Number=0; i < nodes.length(); i++) {
					trace("*** "+i+" id=" + nodes[i].@id);
					san_no = i;
					if( nodes[i].@id == san_id ) { trace(i); break; };				
				}//for			
				trace("san_no="+san_no);
				trace(">> loading entity san :");				
				//this.loadSANInEditor( this.entsanXML.entity.(attribute("id")==entity_id).sans[0],san_no);
				trace(">> WILL LOAD SAN :\n" 
					+ this.entsanXML.entity.(@id==entity_id).sans[0]);
				this.loadSANInEditor( this.entsanXML.entity.(@id==entity_id).sans[0],san_no);								
			} 
			else if (treeEntities.selectedItem.parent().parent().localName()=="apool") {
				var apool_id = treeEntities.selectedItem.parent().parent().@id;
				var entity_id:String = treeEntities.selectedItem.parent().parent().parent().@id;
				trace(">> loading action pool san :");
				trace(apool_id);
				trace(entity_id);				
				//trace(this.entsanXML.entity.(attribute("id")==entity_id).apool.(@id==apool_id));
				//trace(this.entsanXML.entity.(attribute("id")==entity_id));
				//find the number of the san						
				var nodes = treeEntities.selectedItem.parent().children();
				trace("entity parent item = " +treeEntities.selectedItem.parent().localName());
				trace(nodes);
				if( nodes == null ) return;
				for(var i:Number=0; i < nodes.length(); i++) {
					trace("*** "+i+" id=" + nodes[i].@id);
					san_no = i;
					if( nodes[i].@id == san_id ) { trace(i); break; };				
				}//for
				trace(">> WILL LOAD SAN :\n" 
					+ this.entsanXML.entity.(attribute("id")==entity_id).apool.(@id==apool_id).sans[0]);
				this.loadSANInEditor(
					this.entsanXML.entity.(attribute("id")==entity_id).apool.(@id==apool_id).sans[0],san_no
				) 
			}
			if ((this.tabSANEditView).selectedIndex == 1)
				sanTreeViewerEmbeded.renderSAN(this.sanXML,selectedSANIndex,true,true);
			else if ((this.tabSANEditView).selectedIndex == 0) {
				
			}
			(this.vsEntityTreeItemEditor as ViewStack).selectedIndex = 3;
			break;
		case "entity":
			(this.vsEntityTreeItemEditor as ViewStack).selectedIndex = 1; 
			break;
		case "context":
			(this.vsEntityTreeItemEditor as ViewStack).selectedIndex = 2;
			break;
		case "apool":			
			(this.vsEntityTreeItemEditor as ViewStack).selectedIndex = 5;
			break;
		case "global":			
			(this.vsEntityTreeItemEditor as ViewStack).selectedIndex = 6;
			break;
		case "g":
		case "s":
		case "c":
		case "a":
			txtMessage.text = "Please select the parent SAN to edit this node";
			(this.vsEntityTreeItemEditor as ViewStack).selectedIndex = 4; //message			
			break;
		default:
			(this.vsEntityTreeItemEditor as ViewStack).selectedIndex = 4; //welcome message
			txtMessage.text = "";
			trace(treeEntities.selectedItem.localName());
	}
}


private function onTreeSANChange():void {
	var lbl:String = "ITEM DETAILS";
	if (this.treeSAN.selectedItem!=null) {
		this.ribbonTabNav.selectedIndex = 2;
		switch (treeSAN.selectedItem.localName()) {
			case "a": 
				lbl = "ACTION DETAILS";
				currentState = 'showAction';
				break;
			case "s": 
				lbl = "SITUATION DETAILS";
				currentState = 'showSituation';
				break;
			case "c": 
				lbl = "CONDITION DETAILS";
				currentState = 'showCondition';
				break;
			case "g": 
				lbl = "GOAL DETAILS";
				currentState = 'showGoal';
				break;
			case "d": 
				lbl = "DECORATOR DETAILS";
				currentState = 'showDecorator';
				break;
			default:
				lbl = "ITEM DETAILS";
		}
	} else lbl = "ITEM DETAILS";
	//this.lblItemType.text = lbl;
	//this.rightAccordion.label = lbl;
}

private function tree_iconFunc(item:Object):Class {
	var iconClass:Class;
	//iconClass = todoIcon;    
	switch (XML(item).localName()) {
		case "a":
			iconClass = actIcon;
			break;
		case "c":
			iconClass = ctxIcon;
			break;
		case "g":
			iconClass = goaIcon;
			break;                    
		case "s":
			iconClass = sitIcon;
			break;
		case "d":
			iconClass = decIcon;
			break;
	}
	return iconClass;
}
/*
private function onChangeItemName():void {
this.txtID.text = getIDFromName(this.txtName.text);
this.treeSAN.selectedItem.@id = this.txtID.text;
this.treeSAN.selectedItem.@name = this.txtName.text;
}
*/

private function getTimeStamp():String {
	return new Date().getTime().toString();
}

private function enableGUI(v:Boolean):void {
	(treeSAN as Tree).enabled = v;
}

///////////////// FILE HANDLING ////////////////////////////////////////// 
import flash.net.FileReference;
import flash.net.FileFilter;

import flash.events.IOErrorEvent;
import flash.events.Event;

import flash.utils.ByteArray;

//FileReference Class well will use to load data
import editors.SANItemEditor;
import mx.core.Application;
import util.Validator;
import gui.PreviewN3Window;

private var fr:FileReference;

//File types which we want the user to open
private static const FILE_TYPES:Array = [new FileFilter("SAN File", "*.san;*.san.xml")];

//called when the user clicks the load file button
private function onLoadFileClick(e:Event):void
{
	//create the FileReference instance
	fr = new FileReference();	
	//listen for when they select a file
	fr.addEventListener(Event.SELECT, onFileSelect);
	//listen for when then cancel out of the browse dialog
	fr.addEventListener(Event.CANCEL,onCancel);
	this.enableGUI(false);
	//open a native browse dialog that filters for text files
	fr.browse(FILE_TYPES);
}

/************ Browse Event Handlers **************/

//called when the user selects a file from the browse dialog
private function onFileSelect(e:Event):void
{
	//listen for when the file has loaded
	fr.addEventListener(Event.COMPLETE, onLoadComplete);
	//listen for any errors reading the file
	fr.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
	//load the content of the file
	//requires project->compiler->compiler settings-> flash player version = 10.0.0
	fr.load();
}

//called when the user cancels out of the browser dialog
private function onCancel(e:Event):void
{
	trace("File Browse Canceled");
	fr = null;
}

/************ Select Event Handlers **************/

//called when the file has completed loading
private function onLoadComplete(e:Event):void
{
	//get the data from the file as a ByteArray
	var data:ByteArray = fr.data;	
	var xmlStr:String =  data.readUTFBytes(data.bytesAvailable);
	/*
	this.sanXML = new XML(xmlStr);	
	this.sanXMLList = null;	
	this.sanXMLList = new XMLList(sanXML.san[0]);
	*/
	loadEntitiesFromXMLString(xmlStr);
	fr = null;
}

private function loadEntitiesFromXMLString(xmlStr:String):void {
	this.entsanXML = new XML(xmlStr);
	loadSANInEditor(entsanXML.entity[0].sans[0],0);
}

private function loadSANInEditor(_sanXML:XML,sanIndex:int):void {
	trace("@loadSANInEditor : " + this);
	trace(sanIndex);
	trace(_sanXML);	
	//if (sanXML==null) {
	//	Alert.show("Internal Error: SAN not found.");
	//	return;
	//}
	this.sanXML = _sanXML;			
	this.sanXMLList = null;
	//this.sanXMLList = new XMLList(entsanXML.entity[0].sans.san[0]);
	this.sanXMLList = new XMLList(sanXML.san[sanIndex]);
	this.selectedSANIndex = sanIndex;
	trace("---- SAN XMLList ----");
	trace(sanXMLList);
	//this.entsanXMLList = new XMLList(entsanXML.entity);
	this.entsanXMLList = new XMLList(entsanXML.children()); //show also global
	(treeSAN as Tree).invalidateDisplayList();
	this.vstackProperties.selectedIndex = 0;
	this.enableGUI(true);
}

//called if an error occurs while loading the file contents
private function onLoadError(e:IOErrorEvent):void
{
	trace("Error loading file : " + e.text);
}

/// file save code
//called when the user clicks the load file button
private function onBeginSANFileSave(e:Event):void
{
	//create the FileReference instance
	fr = new FileReference();				
	//listen for the file has been saved
	fr.addEventListener(Event.COMPLETE, onFileSave);
	//listen for when then cancel out of the save dialog
	fr.addEventListener(Event.CANCEL,onSaveCancel);
	//listen for any errors that occur while writing the file
	fr.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
	//open a native save file dialog, using the default file name
	//fr.save(inputField.text, DEFAULT_FILE_NAME);
	//fr.save(this.sanXML.toString());
	
	fr.save(this.entsanXML.toXMLString()); //file containing also the entities
}

private function onSANExport(e:Event):void
{
	//create the FileReference instance
	fr = new FileReference();				
	//listen for the file has been saved
	fr.addEventListener(Event.COMPLETE, onFileSave);
	//listen for when then cancel out of the save dialog
	fr.addEventListener(Event.CANCEL,onSaveCancel);
	//listen for any errors that occur while writing the file
	fr.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
	//open a native save file dialog, using the default file name
	//fr.save(inputField.text, DEFAULT_FILE_NAME);	
	//fr.save(c.getN3(this.sanXML),"san."+this.sanXML.san[0].@id+".n3");
	fr.save(c.getN3(this.entsanXML),"san."+this.entsanXML.entity[0].@id+".n3");
	
}

private function onSANExportN3(e:Event):void {
	
	var win:PreviewN3Window=PreviewN3Window(PopUpManager.createPopUp( this, PreviewN3Window , true));
	win.width = mx.core.Application.application.width - 200;
	win.height = mx.core.Application.application.height - 150;
	win.x = 100;
	win.y = 75;
	win.n3str = c.getN3(this.entsanXML); 
}

/***** File Save Event Handlers ******/

//called once the file has been saved
private function onFileSave(e:Event):void
{
	trace("File Saved");
	fr = null;
}

//called if the user cancels out of the file save dialog
private function onSaveCancel(e:Event):void
{
	trace("File save select canceled.");
	fr = null;
}

//called if an error occurs while saving the file
private function onSaveError(e:IOErrorEvent):void
{
	trace("Error Saving File : " + e.text);
	fr = null;
}

// New san

private function onNewFile(e:Event):void
{
	loadEntitiesFromXMLString(this.templateENTSAN);
	/*
	this.entsanXML = new XML(this.templateENTSAN);
	this.sanXML = entsanXML.entity[0].sans[0];
	
	this.sanXMLList = null;			
	this.sanXMLList = new XMLList(entsanXML.entity[0].sans.san[0]);
	this.entsanXMLList = new XMLList(entsanXML.entity);
	
	(treeSAN as Tree).invalidateDisplayList();			
	this.enableGUI(true);
	*/
	fr = null;	
}

private function btbarClick(event:ItemClickEvent):void {
	this.vstackProperties.selectedIndex = event.index;
}

private function onEditDetails(e:Event):void {
	//Alert.show(this.currentState.toString());
	var win:SANItemEditor=SANItemEditor(PopUpManager.createPopUp( this, SANItemEditor , true));
	win.treeSAN = this.treeSAN;
	win.sanXML = this.sanXML;
	win.init(this.currentState);
	win.width = Application.application.stage.width - 100;
	win.x = 50;
	win.height = Application.application.stage.height - 60;
	win.y = 20;
	
}

private function getItemTip(item:Object):String { 
	var node:XML = XML(item);
	var atype:String = (node as XML).localName().toString();
	//return "[MESSAGE] : " + (node as XML).localName();
	switch (atype) {
		case "g":
			return "Goal: " + node.@name;
			break;
		case "s":
			return "Situation" + "\n" + node.@definedBy;
			break;
		case "c":
			return "Condition" + "\n" + node.@definedBy;
			break;
		case "a":
			return "Action: " + node.@name;
			break;
		case "d":
			return "Decorator";
			break;
	}
	return "";
} 

private function onExpandAll(status:Boolean):void {
	//expandTree(this.sanXML..san[0]);	
	for (var i:int = 0; i < this.treeSAN.dataProvider.length; i ++){
		this.treeSAN.expandChildrenOf(this.treeSAN.dataProvider[i], status);
	}
}


private function onValidateSAN():void {
	trace("onValidateSAN");
	var msgID:String = util.Validator.checkUniqueIDs(this.entsanXML,null); //checkUniqueIDs(this.sanXML..san[0],null);
	if (msgID != "") Alert.show("SAN is not valid.\n"+msgID);
	else Alert.show("SAN is valid.\n");
}

////TREE DRUG DROP:
// Called when the user moves the drag proxy onto the drop target.
private function treeDragEnterHandler(event:DragEvent):void {
	
	//accept if source ...
	//if (event.dragSource.hasFormat('color')) {
	trace(event.draggedItem);	
	// Get the drop target component from the event object.
	var dropTarget:Tree=Tree(event.currentTarget);
	// Accept the drop.
	DragManager.acceptDragDrop(dropTarget);
	//}
}

// Called if the target accepts the dragged object and the user 
// releases the mouse button while over the Canvas container. 
private function treeDragDropHandler(event:DragEvent):void {
	
	// Get the data identified by the color format 
	// from the drag source.
	//var data:Object = event.dragSource.dataForFormat('color');
	// Set the canvas color.
	//myCanvas.setStyle("backgroundColor", data);
} 