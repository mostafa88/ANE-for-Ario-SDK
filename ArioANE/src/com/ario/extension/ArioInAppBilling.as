package com.ario.extension
{
	public class ArioInAppBilling
	{
		public function ArioInAppBilling()
		{
			// empty construcotre
		}
		public function GetSkuDetails(skuList:String, callback:Function) : void {
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("GetSkuDetails", skuList, reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}	
		public function Buy(sku:String,developerPayload:String, callback:Function) : void {
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("Buy", sku,developerPayload , reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		
		public function Consume(purchaseToken:String, callback:Function) : void {
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("Consume", purchaseToken, reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		public function GetInventory(callback:Function) : void {
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("GetInventory", reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		
	}
}