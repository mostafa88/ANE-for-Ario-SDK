package com.ario.extension {
	public class Utility {
		
		// make a json string with the resultCode and return it to invocker bay calling the callback function.
		public static function HandleAsynchFunctionErrorResult(callback:Function, resultCode:int, reqCode:String):void
		{
			// return an json with error result
			var response:String = '{"result":' + String(resultCode) + '}';
			callback(response);
			// clear the map
			delete Global.callbackMap[reqCode];
		}
	}
}
