package com.ario.extension
{
	public class ArioAchievement
	{
		public function ArioAchievement()
		{
			// empty constructor 
		}
		public function GetGameAchievements(callback:Function): void
		{
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("GetGameAchievements", reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		public function GetStatus(achievementId:int, callback:Function):void{
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("GetStatus",achievementId, reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		public function Unlock(achievementId:int, callback:Function):void{
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("Unlock",achievementId, reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		public function ResetStatus(achievementId:int, callback:Function):void{
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("ResetStatus",achievementId, reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		public function Increment(achievementId:int, step:int, callback:Function):void
		{
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("Increment",achievementId, step, reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		public function SetStep(achievementId:int, step:int, callback:Function):void
		{
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("SetStep",achievementId, step, reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		public function ShowAchievement():void
		{
			Global.extContext.call("ShowAchievement");
		}
	}
}