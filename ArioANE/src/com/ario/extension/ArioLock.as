package com.ario.extension
{
	import com.ario.extension.LockResult;
	
	public class ArioLock
	{
		public function ArioLock()
		{
			// empty construcotr
		}
		
		// return purchase result code and purchase token
		public function ValidatePurchase():LockResult
		{
			var token:String = Global.extContext.call("CheckPurchase") as String;
			var result:LockResult 
			
			// if token lengh is larget than 5 digit, then it is purchase token.
			if(token.length > 5 ) // suppose that the result code is at most 5 digits
			{
				// make a response with resultcode 0 and token and return to user.
				result = new LockResult(ArioResultCode.RESULT_OK,token);
			}
			else // purhcase not valid 
			{
				if( isNaN( parseInt(token,10)) ) // 10 is radix
				{
					// an error accoured
					result = new LockResult(ArioResultCode.RESULT_ERROR,"");
				}
				else 
				{
					// make a response with resultcode and empty token and return to user.
					var resultCode:int =  parseInt(token,10);
					result = new LockResult(resultCode,"");
				}
			}
			
			return result;
		}
		
		public function ValidatePurchaseAsynch(callback:Function):void
		{
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("CheckPurchaseAsynch",reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result != ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
	}
}