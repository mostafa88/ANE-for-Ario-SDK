package com.ario.test{ 
	import com.ario.extension.ArioInterface;
	import com.ario.extension.ArioResultCode;
	
	import flash.events.MouseEvent;
	import mx.core.FlexGlobals;
	
	
	
	
	public class ArioTest {
		
		
		private var packageName:String = ""; // your package name
		private var inAppPurchasePublicKey:String = ""; // your game base64 public key
		private var leaderboardPublicKey:String = ""; // leaderboard public key
		private var achievementPublickey:String = ""; // achievement public key
		
		// user buttons
		public function onClick_btn_user_id(event:MouseEvent):void {
			//Alert.show("Hello World!");			
			var userId:int = ArioInterface.User.GetId();
			FlexGlobals.topLevelApplication.reportText.text = userId;
			trace(userId);
		}
		public function onClick_btn_user_profile(event:MouseEvent):void {
			ArioInterface.User.GetProfile(onAsynchRecived);
		}
		public function onClick_btn_user_isLogin(event:MouseEvent):void {
			var res:Boolean = ArioInterface.User.IsLogin();
			FlexGlobals.topLevelApplication.reportText.text = res;
		}
		public function onClick_btn_user_avatar_id(event:MouseEvent):void {
			var res:int = ArioInterface.User.GetAvatarId();
			FlexGlobals.topLevelApplication.reportText.text = res;
		}
		public function onClick_btn_user_level(event:MouseEvent):void {
			var res:int = ArioInterface.User.GetLevel();
			FlexGlobals.topLevelApplication.reportText.text = res;
		}
		
		public function onAsynchRecived(msg:String): void
		{
			FlexGlobals.topLevelApplication.reportText.text = msg;
		}
		
		public function onInitialize():void 
		{
			
		}
		public function onPreInitialize():void 
		{
		}
		public function onCreateComplete():void 
		{	
		}
		public function onApplicationComplete():void
		{
			var initResult:int = ArioInterface.Init(packageName,inAppPurchasePublicKey,leaderboardPublicKey,achievementPublickey);
			if( initResult != ArioResultCode.RESULT_OK)
			{
				FlexGlobals.topLevelApplication.reportText.text = "cannot init ario, error:" + initResult;
				trace(initResult);
			}
		}
		
	}
}