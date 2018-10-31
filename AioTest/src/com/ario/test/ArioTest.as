package com.ario.test{ 
	import com.ario.extension.ArioInterface;
	import com.ario.extension.ArioResultCode;
	import com.ario.extension.LockResult;
	
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	
	
	
	
	public class ArioTest {
		
		
		private var packageName:String = "info.medrick.footcardiapc"; // your package name
		private var inAppPurchasePublicKey:String = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDRtIosWXESSR+LkrLYkgKZpbjwEpN/tNkYuRBsp0lTM2ELh0/cE1rSwrRaAE4H2rXL2g3Z8gSVVSF8eYb+plhl4PdphOcj9lIP8/QagF7pTdrvpUsNNss5aXnpju1+scfnYarnitdYq5E1Ol5o/k6ib06IR+p6k536uN3nZ20kQwIDAQAB"; // your game base64 public key
		private var leaderboardPublicKey:String = "eb649f9a-bb75-4dab-8fe1-29aea7e87a7a"; // leaderboard public key
		private var achievementPublickey:String = "eb649f9a-bb75-4dab-8fe1-29aea7e87a7a"; // achievement public key
		
		// clear btn.
		public function onClick_btn_clear(event:MouseEvent):void {
			FlexGlobals.topLevelApplication.reportText.text = "";
		}
		// user buttons
		public function onClick_btn_user_id(event:MouseEvent):void {
			//Alert.show("Hello World!");			
			var userId:int = ArioInterface.User.GetId();
			FlexGlobals.topLevelApplication.reportText.text += "\n" + userId;
			trace(userId);
		}
		public function onClick_btn_user_profile(event:MouseEvent):void {
			ArioInterface.User.GetProfile(onAsynchRecived);
		}
		public function onClick_btn_user_isLogin(event:MouseEvent):void {
			var res:Boolean = ArioInterface.User.IsLogin();
			FlexGlobals.topLevelApplication.reportText.text += "\n" + res;
		}
		public function onClick_btn_user_avatar_id(event:MouseEvent):void {
			var res:int = ArioInterface.User.GetAvatarId();
			FlexGlobals.topLevelApplication.reportText.text += "\n" + res;
		}
		public function onClick_btn_user_level(event:MouseEvent):void {
			var res:int = ArioInterface.User.GetLevel();
			FlexGlobals.topLevelApplication.reportText.text += "\n" + res;
		}
		
		// lock button  
		public function onClick_btn_lock(event:MouseEvent):void {
			var res:LockResult = ArioInterface.Lock.ValidatePurchase();
			if(res.result == ArioResultCode.RESULT_OK)
				FlexGlobals.topLevelApplication.reportText.text += "\n" + res.purchaseToken;
			else
				FlexGlobals.topLevelApplication.reportText.text += "\n" + res.result;
			
		}
		public function onClick_btn_lock_asynch(event:MouseEvent):void {
			ArioInterface.Lock.ValidatePurchaseAsynch(onAsynchRecived);
		}
		
		public function onAsynchRecived(msg:String): void
		{
			FlexGlobals.topLevelApplication.reportText.text += "\n" + msg;
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