package com.ario.test{ 
	import com.ario.extension.ArioInterface;
	import com.ario.extension.ArioResultCode;
	import com.ario.extension.LockResult;
	
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	
	
	
	
	public class ArioTest {
		
		
		private var packageName:String = ""; // your package name
		private var inAppPurchasePublicKey:String = ""; // your game base64 public key
		private var leaderboardPublicKey:String = ""; // leaderboard public key
		private var achievementPublickey:String = ""; // achievement public key
		
		////////////////////////////// clear btn  ////////////////////////////// 
		public function onClick_btn_clear(event:MouseEvent):void {
			FlexGlobals.topLevelApplication.reportText.text = "";
		}
		////////////////////////////// user buttons /////////////////////////////// 
		public function onClick_btn_user_id(event:MouseEvent):void {
			//Alert.show("Hello World!");			
			var userId:int = ArioInterface.User.GetId();
			FlexGlobals.topLevelApplication.reportText.text += userId + "\n";
			trace(userId);
		}
		public function onClick_btn_user_profile(event:MouseEvent):void {
			ArioInterface.User.GetProfile(onAsynchRecived);
		}
		public function onClick_btn_user_isLogin(event:MouseEvent):void {
			var res:Boolean = ArioInterface.User.IsLogin();
			FlexGlobals.topLevelApplication.reportText.text += res + "\n";
		}
		public function onClick_btn_user_avatar_id(event:MouseEvent):void {
			var res:int = ArioInterface.User.GetAvatarId();
			FlexGlobals.topLevelApplication.reportText.text += res + "\n";
		}
		public function onClick_btn_user_level(event:MouseEvent):void {
			var res:int = ArioInterface.User.GetLevel();
			FlexGlobals.topLevelApplication.reportText.text += res + "\n";
		}
		
		////////////////////////////// lock buttons /////////////////////////////// 
		public function onClick_btn_lock(event:MouseEvent):void {
			var res:LockResult = ArioInterface.Lock.ValidatePurchase();
			if(res.result == ArioResultCode.RESULT_OK)
				FlexGlobals.topLevelApplication.reportText.text += res.purchaseToken + "\n";
			else
				FlexGlobals.topLevelApplication.reportText.text += res.result + "\n";
			
		}
		public function onClick_btn_lock_asynch(event:MouseEvent):void {
			ArioInterface.Lock.ValidatePurchaseAsynch(onAsynchRecived);
		}
		
		////////////////////////////// In App Billing buttons /////////////////////////////// 
		public function onClick_btn_iab_details(event:MouseEvent):void {
			// sku list is a comma separated list like: FOOT-G1, FOOT-G2
			var skuList:String = FlexGlobals.topLevelApplication.input_sku_detail.text;
			ArioInterface.InAppBilling.GetSkuDetails(skuList,onAsynchRecived);
		}
		public function onClick_btn_iab_buy(event:MouseEvent):void {
			
		}
		public function onClick_btn_iab_consume(event:MouseEvent):void {
			
		}
		public function onClick_btn_iab_inventory(event:MouseEvent):void {
			
		}
		
		public function onAsynchRecived(msg:String): void
		{
			FlexGlobals.topLevelApplication.reportText.text +=  msg + "\n";
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
				FlexGlobals.topLevelApplication.reportText.text = "cannot init ario, error:" + initResult + "\n";
				trace(initResult);
			}
		}
		
	}
}