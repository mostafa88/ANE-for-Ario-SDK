package com.ario.test{ 
import com.ario.extension.ArioInterface;

import flash.events.MouseEvent;

import mx.core.Application;
import mx.core.ComponentDescriptor;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;




public class ArioTest {
	
	
	private var packageName:String = "info.medrick.footcardiapc";
	private var inAppPurchasePublicKey:String = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDRtIosWXESSR+LkrLYkgKZpbjwEpN/tNkYuRBsp0lTM2ELh0/cE1rSwrRaAE4H2rXL2g3Z8gSVVSF8eYb+plhl4PdphOcj9lIP8/QagF7pTdrvpUsNNss5aXnpju1+scfnYarnitdYq5E1Ol5o/k6ib06IR+p6k536uN3nZ20kQwIDAQAB";
	private var leaderboardPublicKey:String = "eb649f9a-bb75-4dab-8fe1-29aea7e87a7a";
	private var achievementPublickey:String = "b649f9a-bb75-4dab-8fe1-29aea7e87a7a";
	
	public static var nativeInstance:ArioInterface;
	
	
	public function btnSynch_clickHandler(event:MouseEvent):void {
		//Alert.show("Hello World!");
		
		FlexGlobals.topLevelApplication.lblHeader.text = "clicked!"
		//var result:String = nativeInstance.isSupported();
		// FlexGlobals.topLevelApplication.lblHeader.text = result;
			
		var initResult:int = nativeInstance.init(packageName,inAppPurchasePublicKey,leaderboardPublicKey,achievementPublickey);
		FlexGlobals.topLevelApplication.lblHeader.text = initResult;
		trace(initResult);
	
	}
	public function btnASynch_clickHandler(event:MouseEvent):void {
		//Alert.show("Hello World!");
		
		nativeInstance.isSupportedAsynch(onAsynchRecived);
	}
	
	
	public function onAsynchRecived(msg:String): void
	{
		FlexGlobals.topLevelApplication.lblHeader.text = msg;
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
		nativeInstance = new ArioInterface();
	}

	}
}