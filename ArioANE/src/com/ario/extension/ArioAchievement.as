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
	}
}