package com.ario.extension { 
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class ArioInterface extends EventDispatcher {
		
		private static var instance:ArioInterface = null;
		public static var User:ArioUser = null;
		public static var Lock:ArioLock = null;
		public static var InAppBilling:ArioInAppBilling = null;
		
		public function ArioInterface(target:EventDispatcher=null)
		{
			super(target);
			
			try{
				//trace("extension before create",extContext.toString());
				Global.extContext = ExtensionContext.createExtensionContext(Global.EXTENSION_ID,"");
				trace("extension after create",Global.extContext.toString());
			}
			catch(e:Error)
			{
				trace(e.message());
				
			}
			// set global event status handler
			Global.extContext.addEventListener(StatusEvent.STATUS, onStatus); 
			// instanciate Ario services
			User = new ArioUser();
			Lock = new ArioLock();
			InAppBilling = new ArioInAppBilling();
			
			instance = this;	
		}
		
		public static function Init(packageName:String, inAppPurchase_publicKey:String="",
							 leaderboard_publicKey:String="",achivemnet_publicKey:String=""): int 
		{
			if(instance == null)
				instance = new ArioInterface();
			
			var result:int = Global.extContext.call("Init",packageName,inAppPurchase_publicKey,leaderboard_publicKey,achivemnet_publicKey) as int;
			return result;
		}
		
		// this function invoked when an event emit from native code.
		// event.level is the name of the function that emit event
		private function onStatus(event:StatusEvent):void 
		{ 
			trace(event.code);
			trace(event.level);
			//check if a callback already registerd for the reqcode
			if(Global.callbackMap.hasOwnProperty(event.code))
			{
				// call the callback method with the returned response
				Global.callbackMap[event.code](event.level);
				// remove the callback from map
				delete Global.callbackMap[event.code];
			}
		} 
		public function dispose(): void { 
			Global.extContext.dispose(); 
			// Clean up other resources that the TVChannelController instance uses. 
		}
	}
} 