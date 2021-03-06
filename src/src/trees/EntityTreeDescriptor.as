package trees
{
	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.collections.XMLListCollection;
	import mx.controls.treeClasses.*;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
				
	public class EntityTreeDescriptor implements ITreeDataDescriptor
	{
		public function SANTreeDescriptor()
		{
		}
		
		public function getChildren(node:Object, model:Object = null):ICollectionView {
			
			var xml:XML = node as XML;
			var result:XMLListCollection = 
				new XMLListCollection(
					 xml.child("global")					
					+ xml.child("context")
					+ xml.child("sans")
					+ xml.child("apools")
					+ xml.child("apool")					
					+ xml.child("san") 
					+ xml.child("attr")
					+ xml.child("g")
					// added in v3.1.1
					+ xml.child("s")
					+ xml.child("c")
					+ xml.child("a")
				);//this works - filters assign nodes -- the order is the order they will be placed in the tree !
			/*
			xml.child("a") + 
			xml.child("s") + 
			xml.child("c") +
			xml.child("g")
			xml.child("d")
			*/
			return result;      
		}
		
		public function hasChildren(node:Object, model:Object = null):Boolean {
			var nodexml:XML = new XML(node);
			var result:Boolean = false;
			try {
				//trace (  (getChildren(node,model) as XMLListCollection).length + " children" );
				if ((getChildren(node,model) as XMLListCollection).length > 0) 
					result = true ;
			} catch (e:Error) {}	
			return result;
		}
		
		public function isBranch(node:Object, model:Object = null):Boolean {
			var nodexml:XML = (node as XML);
			//if (nodexml.localName() == "assigned") return false;
			//else 
			return hasChildren(node, model);
		}
		
		public function getData(node:Object, model:Object=null):Object
		{
			return super.getData(node,model);
		}
		
		public function addChildAt(parent:Object, newChild:Object, index:int, model:Object=null):Boolean
		{
			return super.addChildAt(parent, newChild, index, model);
		}
		
		public function removeChildAt(parent:Object, child:Object, index:int, model:Object=null):Boolean
		{
			return removeChildAt(parent,child,index,model);
		}
		
	}
}