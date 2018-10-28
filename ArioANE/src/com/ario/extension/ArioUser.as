package com.ario.extension { 
	
	public class ArioUser{
		
		public function ArioUser()
		{
			// empty constructor
		}
		public function IsLogin(): Boolean{
			var result:Boolean = Global.extContext.call("IsLogin") as Boolean;
			return result;
		}
		public function GetId() : int{
			var result:int = Global.extContext.call("GetUserId") as int;
			return result;
		}
		public function GetAvatarId() : int{
			var result:int = Global.extContext.call("GetAvatarId") as int;
			return result;
		}
		public function GetLevel() : int{
			var result:int = Global.extContext.call("GetLevel") as int;
			return result;
		}
		public function GetProfile(callback:Function) : void {
			// generating a random request code and save callback function.
			var reqCode:String = Math.ceil(Math.random()*int.MAX_VALUE).toString();
			trace(reqCode);
			Global.callbackMap[reqCode] = callback;
			var result:int = Global.extContext.call("GetProfile",reqCode) as int;
			if(result!= ArioResultCode.RESULT_OK)
			{
				Utility.HandleAsynchFunctionErrorResult(callback,result,reqCode);
			}
		}	
	}
}

