package com.ario.extension { 
	import com.ario.extension.ArioResultCode;
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class ArioInterface extends EventDispatcher {
		
		

		private var extContext:ExtensionContext; 
		private var isSupport:String = "";
		
		// callback handler
		private var generalCallback:Function;
		
		public function ArioInterface()
		{
			extContext = ExtensionContext.createExtensionContext("com.air.extension.ario","");
			extContext.addEventListener(StatusEvent.STATUS, onStatus); 
			generalCallback = null;
		}
		
		public function init(packageName:String, inAppPurchase_publicKey:String="",
							 leaderboard_publicKey:String="",achivemnet_publicKey:String=""): int 
		{
			if(true)
			var result:int = extContext.call("init",packageName,inAppPurchase_publicKey,leaderboard_publicKey,achivemnet_publicKey) as int;
			return result;
		}
		
		// this function invoked when an event emit from native code.
		// event.level is the name of the function that emit event
		private function onStatus(event:StatusEvent):void 
		{ 
			if (event.level == "IsSupportedAsynch") 
			{ 
				trace(event.code);
				
				if(generalCallback)
					generalCallback("Asynch سلام");
				else
				{
					trace("generalCallback is null");
				}
				generalCallback = null;
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
		public function isSupportedAsynch(callback:Function): void
		{
			generalCallback = callback;
			extContext.call("IsSupportedAsynch",true,"salam");
			return;
		}
	}
} 