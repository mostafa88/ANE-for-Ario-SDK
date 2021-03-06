package com.ario.test{ 
	import com.ario.extension.ArioInAppBilling;
	import com.ario.extension.ArioInterface;
	import com.ario.extension.ArioResultCode;
	import com.ario.extension.LockResult;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.core.FlexGlobals;
	
	import spark.components.ComboBox;
	
	
	
	
	public class ArioTest {
		
		
		private var packageName:String = ""; // your package name
		private var inAppPurchasePublicKey:String = ""; // your game base64 public key
		private var leaderboardPublicKey:String = ""; // leaderboard public key
		private var achievementPublickey:String = ""; // achievement public key
		// leaderboard data
		[Bindable]
		public var array_leaderboards_name:ArrayCollection;
		[Bindable]
		public var array_collectionType:ArrayCollection;
		[Bindable]
		public var array_timeFrame:ArrayCollection;
		
		public var array_leaderboards_Obj:ArrayCollection;
		
		// achievement data
		[Bindable]
		public var array_achievements_name:ArrayCollection;
		
		public var array_achievements_obj:ArrayCollection;
		
		
		
		public function ShowText(text:String):void{
			FlexGlobals.topLevelApplication.reportText.text += text + "\n";
		}
		
		////////////////////////////// clear btn  ////////////////////////////// 
		public function onClick_btn_clear(event:MouseEvent):void {
			FlexGlobals.topLevelApplication.reportText.text ="";
		}
		////////////////////////////// user buttons /////////////////////////////// 
		public function onClick_btn_user_id(event:MouseEvent):void {
			//Alert.show("Hello World!");			
			var userId:int = ArioInterface.User.GetId();
			ShowText(userId.toString());
			trace(userId);
		}
		public function onClick_btn_user_profile(event:MouseEvent):void {
			ArioInterface.User.GetProfile(onAsynchRecived);
		}
		public function onClick_btn_user_isLogin(event:MouseEvent):void {
			var res:Boolean = ArioInterface.User.IsLogin();
			ShowText(res.toString());
		}
		public function onClick_btn_user_avatar_id(event:MouseEvent):void {
			var res:int = ArioInterface.User.GetAvatarId();
			ShowText(res.toString());
		}
		public function onClick_btn_user_level(event:MouseEvent):void {
			var res:int = ArioInterface.User.GetLevel();
			ShowText(res.toString());
		}
		
		////////////////////////////// lock buttons /////////////////////////////// 
		public function onClick_btn_lock(event:MouseEvent):void {
			var res:LockResult = ArioInterface.Lock.ValidatePurchase();
			if(res.result == ArioResultCode.RESULT_OK)
				ShowText(res.purchaseToken);
			else
				ShowText(res.result.toString());
			
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
			
			var sku:String = FlexGlobals.topLevelApplication.input_sku.text;
			var developerPayload:String = "A SIMPLE DEVELOPER PAYLOAD";
			ArioInterface.InAppBilling.Buy(sku,developerPayload,onPurchaseFinished);
		}
		public function onClick_btn_iab_consume(event:MouseEvent):void {
			var purchaseToken:String = FlexGlobals.topLevelApplication.input_token.text;
			if( purchaseToken.length > 0)
			{
				ArioInterface.InAppBilling.Consume(purchaseToken,onConsumeFinish);
			}
			
			else
				ShowText("Noting to cunsume!! Please buy an item first...");
		}
		public function onClick_btn_iab_inventory(event:MouseEvent):void {
			ArioInterface.InAppBilling.GetInventory(onAsynchRecived);
		}
		private function onPurchaseFinished(msg:String): void
		{
			var data:Object = JSON.parse(msg);
			if(data.hasOwnProperty("purchaseToken"))
			{
				FlexGlobals.topLevelApplication.input_token.text = data["purchaseToken"];
			}
			onAsynchRecived(msg);
		}
		private function onConsumeFinish(msg:String):void
		{
			var data:Object = JSON.parse(msg);
			if(data.hasOwnProperty("result"))
			{
				var result:int = data["result"];
				if(result == ArioResultCode.RESULT_OK)
				{
					FlexGlobals.topLevelApplication.input_token.text = "";
				}	
			}
			onAsynchRecived(msg);
		}
		////////////////////////////// Leaderboard buttons /////////////////////////////// 
		public function onClick_btn_leaderboard_get_leaderboards(event:MouseEvent):void{
			ArioInterface.Leaderboard.GetLeaderboards(onLeaderboardFinish);
		}
		public function onClick_btn_leaderboard_get_scores(event:MouseEvent):void
		{
			
			// finding leaderboard Id
			var leaderboardIndex:int = FlexGlobals.topLevelApplication.comboBox_leaderboards.selectedIndex;
			if(leaderboardIndex < 0) // there is no leaderboard
			{
				ShowText("No leaderboard selected! Please call Get leaderboards first and select a leaderboard ID");
			}
			else
			{
				var leaderboardId:int = array_leaderboards_Obj[leaderboardIndex]["id"];
				// finding collection type
				var collectionType:int = FlexGlobals.topLevelApplication.comboBox_collectionType.selectedIndex;
				// finding time frame
				var timeFrame:int = FlexGlobals.topLevelApplication.comboBox_timeFrame.selectedIndex;
				// finding limit and offset
				var offset:int = parseInt(FlexGlobals.topLevelApplication.input_leaderboard_offset.text,10);
				var limit:int = parseInt(FlexGlobals.topLevelApplication.input_leaderboard_limit.text,10);
				
				ArioInterface.Leaderboard.GetScores(leaderboardId,collectionType,timeFrame,offset,limit,onAsynchRecived);
			}
		
		}
		public function onClick_btn_leaderboard_get_my_rank(event:MouseEvent):void
		{
			// finding leaderboard Id
			var leaderboardIndex:int = FlexGlobals.topLevelApplication.comboBox_leaderboards2.selectedIndex;
			if(leaderboardIndex < 0) // there is no leaderboard
			{
				ShowText("No leaderboard selected! Please call Get leaderboards first and select a leaderboard ID");
			}
			else
			{
				var leaderboardId:int = array_leaderboards_Obj[leaderboardIndex]["id"];
				// finding collection type
				var collectionType:int = FlexGlobals.topLevelApplication.comboBox_collectionType2.selectedIndex;
				// finding time frame
				var timeFrame:int = FlexGlobals.topLevelApplication.comboBox_timeFrame2.selectedIndex;
				// finding up and down limit
				var upLimit:int = parseInt(FlexGlobals.topLevelApplication.input_leaderboard_up_limit.text,10);
				var downLimit:int = parseInt(FlexGlobals.topLevelApplication.input_leaderboard_down_limit.text,10);
				
				ArioInterface.Leaderboard.GetMyRank(leaderboardId,collectionType,timeFrame,upLimit,downLimit,onAsynchRecived);
			}
			
		}
		public function onClick_btn_leaderboard_submit_score(event:MouseEvent):void{
			
			// finding leaderboard Id
			var leaderboardIndex:int = FlexGlobals.topLevelApplication.comboBox_leaderboards3.selectedIndex;
			if(leaderboardIndex < 0) // there is no leaderboard
			{
				ShowText("No leaderboard selected! Please call Get leaderboards first and select a leaderboard ID");
			}
			else
			{
				var leaderboardId:int = array_leaderboards_Obj[leaderboardIndex]["id"];
				// finding value
				var value:Number = parseInt(FlexGlobals.topLevelApplication.input_leaderboard_submit_value.text,10);
				// finding metadata
				var metadata:String = FlexGlobals.topLevelApplication.input_leaderboard_submit_metadata.text;
				
				ArioInterface.Leaderboard.SubmitScore(value,leaderboardId,metadata,onAsynchRecived);
			}
		}
		public function onClick_btn_leaderboard_show_leaderboard(event:MouseEvent):void{
			ArioInterface.Leaderboard.ShowLeaderboard();
		}
		private function onLeaderboardFinish(msg:String):void
		{
			var data:Object = JSON.parse(msg);
			if(data.hasOwnProperty("result"))
			{
				var result:int = data["result"];
				if(result == ArioResultCode.RESULT_OK)
				{
					array_leaderboards_name.removeAll();
					array_leaderboards_Obj.removeAll();
					var count:int =  data["result_number"];
					if(data.hasOwnProperty("message"))
					{
						var messageArray:Array = data["message"];
						
						for(  var i:int = 0 ; i < count ; i++)
						{
							var leader:Object = messageArray[i];
							array_leaderboards_name.addItem(leader["name"]);
							array_leaderboards_Obj.addItem(leader);
						}
						array_leaderboards_name.refresh();
						FlexGlobals.topLevelApplication.comboBox_leaderboards.selectedIndex = 0;
						
					}
				}	
			}
			onAsynchRecived(msg);
		}
		
		////////////////////////////// Achievement buttons /////////////////////////////// 
		public function onClick_btn_achievement_get_achievements(event:MouseEvent):void{
			ArioInterface.Achievement.GetGameAchievements(onAchievementsFinish);
		}
		public function onClick_btn_achievement_get_status(event:MouseEvent):void{
			// finding achievement Id
			var achievementIndex:int = FlexGlobals.topLevelApplication.comboBox_achievements.selectedIndex;
			if(achievementIndex < 0) // there is no leaderboard
			{
				ShowText("No achievement selected! Please call Get achievement first and select a achievement ID");
			}
			else
			{
				var achievementId:int = array_achievements_obj[achievementIndex]["achievement_id"];
				ArioInterface.Achievement.GetStatus(achievementId,onAsynchRecived);
			}
		}
		public function onClick_btn_achievement_unlock(event:MouseEvent):void{
			// finding achievement Id
			var achievementIndex:int = FlexGlobals.topLevelApplication.comboBox_achievements.selectedIndex;
			if(achievementIndex < 0) // there is no leaderboard
			{
				ShowText("No achievement selected! Please call Get achievement first and select a achievement ID");
			}
			else
			{
				var achievementId:int = array_achievements_obj[achievementIndex]["achievement_id"];
				ArioInterface.Achievement.Unlock(achievementId,onAsynchRecived);
			}
		}
		// warning: do not use this function in development build
		public function onClick_btn_achievement_reset(event:MouseEvent):void{
			// finding achievement Id
			var achievementIndex:int = FlexGlobals.topLevelApplication.comboBox_achievements.selectedIndex;
			if(achievementIndex < 0) // there is no leaderboard
			{
				ShowText("No achievement selected! Please call Get achievement first and select a achievement ID");
			}
			else
			{
				var achievementId:int = array_achievements_obj[achievementIndex]["achievement_id"];
				ArioInterface.Achievement.ResetStatus(achievementId,onAsynchRecived);
			}
		}
		public function onClick_btn_achievement_increment(event:MouseEvent):void{
			// finding achievement Id
			var achievementIndex:int = FlexGlobals.topLevelApplication.comboBox_achievements.selectedIndex;
			if(achievementIndex < 0) // there is no leaderboard
			{
				ShowText("No achievement selected! Please call Get achievement first and select a achievement ID");
			}
			else
			{
				var achievementId:int = array_achievements_obj[achievementIndex]["achievement_id"];
				// finding achievement step
				var step:int = parseInt(FlexGlobals.topLevelApplication.input_achievements_value.text);
				ArioInterface.Achievement.Increment(achievementId,step,onAsynchRecived);
			}
		}
		public function onClick_btn_achievement_set_step(event:MouseEvent):void{
			// finding achievement Id
			var achievementIndex:int = FlexGlobals.topLevelApplication.comboBox_achievements.selectedIndex;
			if(achievementIndex < 0) // there is no leaderboard
			{
				ShowText("No achievement selected! Please call Get achievement first and select a achievement ID");
			}
			else
			{
				var achievementId:int = array_achievements_obj[achievementIndex]["achievement_id"];
				// finding achievement step
				var step:int = parseInt(FlexGlobals.topLevelApplication.input_achievements_value.text);
				ArioInterface.Achievement.SetStep(achievementId,step,onAsynchRecived);
			}
		}
		
		public function onClick_btn_achievement_show(event:MouseEvent):void{
			ArioInterface.Achievement.ShowAchievement();
		}
		public function onAchievementsFinish(jsonMsg:String):void
		{
			var data:Object = JSON.parse(jsonMsg);
			if(data.hasOwnProperty("result"))
			{
				var result:int = data["result"];
				if(result == ArioResultCode.RESULT_OK)
				{
					
					array_achievements_name.removeAll();
					array_achievements_obj.removeAll();
					var count:int =  data["result_number"];
					if(data.hasOwnProperty("message"))
					{
						var messageArray:Array = data["message"];
						
						for(  var i:int = 0 ; i < count ; i++)
						{
							var achiev:Object = messageArray[i];
							array_achievements_name.addItem(achiev["name"]);
							array_achievements_obj.addItem(achiev);
						}
						array_achievements_name.refresh();
						FlexGlobals.topLevelApplication.comboBox_achievements.selectedIndex = 0;
						
					}
				}	
			}
			onAsynchRecived(jsonMsg);
		}
		
		
		public function onAsynchRecived(msg:String): void
		{
			ShowText(msg);
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
				ShowText("cannot init ario, error:" + initResult );
				trace(initResult);
			}
			else
			{
				// init leaderboards arrays
				array_leaderboards_name = new ArrayCollection();
				array_leaderboards_Obj = new ArrayCollection();
				
				array_collectionType = new ArrayCollection(["All Users", "Friends"]);
				FlexGlobals.topLevelApplication.comboBox_collectionType.selectedIndex = 0;
				
				array_timeFrame = new ArrayCollection(["DAILY", "WEEKLY","ALL_TIME"]);
				FlexGlobals.topLevelApplication.comboBox_timeFrame.selectedIndex = 2;
				
				// init achievemetn arrays
				array_achievements_name = new ArrayCollection();
				array_achievements_obj = new ArrayCollection();
			}
		}
		
	}
}