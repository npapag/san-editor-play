package trees
{
	import mx.controls.treeClasses.TreeItemRenderer;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.collections.*;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.ButtonLabelPlacement;
	import mx.controls.CheckBox;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.MenuBar;
	import mx.controls.Tree;
	import mx.controls.treeClasses.*;
	import mx.events.MenuEvent;
	import mx.graphics.RectangularDropShadow;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;
	
	public class SANTreeItemRenderer extends TreeItemRenderer
	{
		
		public  var itemXML:XMLList;
		
		public function SANTreeItemRenderer()  
		{			
			super();						
			trace("treeitemrenderer()");
			//this.menubarXML = _menubar.menuitem;									
		}
						
		override public function set data(value:Object):void {
			if (value!=null) {
				super.data = value;
				this.itemXML = XMLList(value);
				if(TreeListData(super.listData).hasChildren)
				{
					setStyle("color", 0xff0000);
					setStyle("fontWeight", 'bold');
				}
				else
				{
					setStyle("color", 0x000000);
					setStyle("fontWeight", 'normal');
				}
			}
		}
		
		// Override the updateDisplayList() method 
		// to set the text for each tree node.      
		override protected function updateDisplayList(unscaledWidth:Number, 
													  unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (this.itemXML != null) {
				//Alert.show(this.itemXML);
				//this.label = itemXML.name[0];
				//Alert.show(this.itemXML.name[0]);
			}
			if (super.data!=null) {
				var tld:TreeListData = TreeListData(super.listData);								
				super.label.text = itemXML.@name;
				//Alert.show(super.label.text);
				super.icon.visible = true;				
				if (super.icon != null) {
					
					switch (itemXML.localName()) {
						case "a":
							if (itemXML.@type.length()>0)								
								super.label.text = itemXML.@type + " action: " + itemXML.@name;															
							else 
								super.label.text = "Action : " + itemXML.@name;
							break;
						case "g":
							super.label.text = "Goal : " + itemXML.@name;
							break;
						case "s":
							super.label.text = "Situation : " + itemXML.@name;
							break;
						case "c":
							super.label.text = "Condition : " + itemXML.@name;
							break;
						case "d":
							if (itemXML.@type.length()>0)								
								super.label.text = itemXML.@type + " decorator: " + itemXML.@name;
							else
								super.label.text = "Decorator : " + itemXML.@name;
							break;
						default:							
							break;
					}
					
				}
				else { //if super icon is null
					
				}
				/*
				if (tld.hasChildren) { 
				//nothing
				} else {
				//nothing
				}*/	
			}
		}
	
		//Tree must have : variableRowHeight="true"
		override protected function measure():void {
			super.measure();
			//if (this.discloseCheckBox.selected || ROLLOVER) {
				//this.measuredHeight = 60;									
			//} else {
				this.measuredHeight = 20;
			//}			
		}
											
	}
}