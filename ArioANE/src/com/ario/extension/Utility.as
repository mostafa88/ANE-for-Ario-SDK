package com.ario.extension {
	public class Utility {
		
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
