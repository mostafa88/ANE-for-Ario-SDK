package com.ario.extension { 
	import flash.external.ExtensionContext;
	import flash.events.EventDispatcher;

	public class ArioInterface extends EventDispatcher {
		
		private var extContext:ExtensionContext; 
		public function ArioInterface()
		{
			extContext = ExtensionContext.createExtensionContext("com.air.extension.ario","sample");
		}
		public function dispose(): void { 
			extContext.dispose(); 
			// Clean up other resources that the TVChannelController instance uses. 
		}
		public function add(a:Number, b:Number):Number
		{
			return a+b;
		}
	}
} 