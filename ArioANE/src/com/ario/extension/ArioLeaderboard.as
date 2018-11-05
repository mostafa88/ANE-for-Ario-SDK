package com.ario.extension
{
	public class ArioLeaderboard
	{
		public static const COLLECTION_TYPE_ALL_USER:int = 0; // berween all users
		public static const COLLECTION_TYPE_FRIENDS:int = 1; // berween friends
		
		public static const TIME_FRAME_DAILY:int = 0; // leaderboard for current day
		public static const TIME_FRAME_WEEKLY:int = 1; // leaderboard for current week
		public static const TIME_FRAME_ALL_TIME:int = 2; // leaderboard for All time
		
		
		public function ArioLeaderboard()
		{
			// empty constroctor
		}
		public function GetLeaderboards( callback:Function) : void 
		{
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("GetLeaderboards", reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}	
		public function GetScores(leaderboardId:int, collectionType:int, timeFram:int, offset:int, limit:int, callback:Function) : void 
		{
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("GetScores",leaderboardId, collectionType, timeFram, offset, limit, reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		public function GetMyRank(leaderboardId:int, collectionType:int, timeFram:int, upLimit:int, downLimit:int, callback:Function) : void 
		{
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("GetMyRank",leaderboardId, collectionType, timeFram, upLimit, downLimit, reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		public function SubmitScore(value:Number, leaderboardId:int, metadata:String, callback:Function):void
		{
			// generating a random request code
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			// save callback function.
			Global.callbackMap[reqCode] = callback;
			// call the function with the request code
			var result:int = Global.extContext.call("SubmitScore",value, leaderboardId, metadata, reqCode) as int;
			// check the first result of asynch funcion, if result was ok, the final response will be emitted by ArioInterface.onStatus function 
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}
		public function  ShowLeaderboard():void
		{
			Global.extContext.call("ShowLeaderboard");
		}
	}
}