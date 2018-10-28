package com.ario.extension{
	import flash.external.ExtensionContext;
	
	public class Global{
		// extension Id
		public static const EXTENSION_ID:String = "com.air.extension.ario";
		// extension context
		public static var extContext:ExtensionContext; 
		// map container to save <reqCode,callback functions>
		public static var callbackMap:Object = new Object();
	}
	// map container to save <req-code,callback functions>
	
}