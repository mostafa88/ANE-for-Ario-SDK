package com.ario.extension
{
	public class LockResult
	{
		public var result:int ;
		public var purchaseToken:String;
		public function LockResult(resultCode:int , token:String)
		{
			result = resultCode;
			purchaseToken = token;
		}
	}
}