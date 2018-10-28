package com.ario.test{ 
import com.ario.extension.ArioInterface;
import com.ario.extension.ArioResultCode;

import flash.events.MouseEvent;

import mx.core.Application;
import mx.core.ComponentDescriptor;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;




public class ArioTest {
	
	
	private var packageName:String = "info.medrick.footcardiapc";
	private var inAppPurchasePublicKey:String = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDRtIosWXESSR+LkrLYkgKZpbjwEpN/tNkYuRBsp0lTM2ELh0/cE1rSwrRaAE4H2rXL2g3Z8gSVVSF8eYb+plhl4PdphOcj9lIP8/QagF7pTdrvpUsNNss5aXnpju1+scfnYarnitdYq5E1Ol5o/k6ib06IR+p6k536uN3nZ20kQwIDAQAB";
	private var leaderboardPublicKey:String = "eb649f9a-bb75-4dab-8fe1-29aea7e87a7a";
	private var achievementPublickey:String = "b649f9a-bb75-4dab-8fe1-29aea7e87a7a";
	
	//public static var nativeInstance:ArioInterface;

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