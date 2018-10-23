package com.ario.extension { 
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;
	import flash.events.StatusEvent;

	public class ArioInterface extends EventDispatcher {
		
		private var extContext:ExtensionContext; 
		private var isSupport:String = "";
		public function ArioInterface()
		{
			extContext = ExtensionContext.createExtensionContext("com.air.extension.ario","");
			extContext.addEventListener(StatusEvent.STATUS, onStatus); 
		}
		
		// this function invoked when an event emit from native code.
		// event.level is the name of the function that emit event
		private function onStatus(event:StatusEvent):void 
		{ 
			if (event.level == "IsSupportedAsynch") 
			{ 
				trace(event.code);
			}     
		} 
		public function dispose(): void { 
			extContext.dispose(); 
			// Clean up other resources that the TVChannelController instance uses. 
		}
		public function add(a:Number, b:Number):Number
		{
			return a+b;
			
		}
		public function isSupported(): String
		{
			isSupport = extContext.call("IsSupported",true,"salam") as String;
			return isSupport;
		}
		public function isSupportedAsynch(): void
		{
			extContext.call("IsSupportedAsynch",true,"salam");
			return;
		}
	}
} 