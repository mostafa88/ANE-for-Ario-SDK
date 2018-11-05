// auto generated header inclucde by visual studio
#include "stdafx.h"
#include "ArioANE.h"

// windows library
#include <winuser.h>

// C library
#include <cstdio>	// printf
#include <cstdlib>  // malloc, free, rand

// C++ library
#include <string>
#include <thread>

//Ario SDK headers
#define ARIO_SDK
#ifdef ARIO_SDK
#include <api.h>
#include <flat/flat_ario_iab_helper.h>
#include <flat/flat_ario_leaderboard.h>
#include <flat/flat_ario_achievement.h>
#include <flat/flat_ario_user.h>
#include <sdk_result_code.h>
// Ario Lock headers
#include <StoreSdkCommon.h>
#endif // ARIO_SDK

//internal headers
#include "FREConverters.h"

// In app billing const definitions
char* SKU_TYPE = "inapp"; // current version only support inapp, so for now we hardcode this sku_type


#ifdef ARIO_SDK
using namespace Ario;
#else
typedef int (__cdecl *Api_Init)(char* packageName);
#endif //ARIO_SDK

//Global object, Used to dispatch event back to AIR
FREContext AIRContext;

void ARIO_CALLING_CONVERSION JsonCallback(int requestCode, int result, int response_size)
{
	FREResult airResult;
	char eventCode[32];
	snprintf(eventCode, sizeof(eventCode), "%d", requestCode);

	std::string stringResponse;
	if (result == RESULT_OK)
	{
		int bufferSize = response_size;
		char* response = new char[bufferSize];
		GetJsonResult(requestCode, response, bufferSize);


		airResult = FREDispatchStatusEventAsync(AIRContext, (const uint8_t*)eventCode, (const uint8_t*)response);
		delete[] response;
	}
	else
	{
		char response[32];
		sprintf(response, "{\"result\":%d}", result);
		airResult = FREDispatchStatusEventAsync(AIRContext,
			(const uint8_t*)eventCode, (const uint8_t*)response);
	}
}


// description: init ario SdK
// number of parameter (argc):
// 0th param: string packageName
// 1st param: string inAppPurchasePublicKey
// 2nd param: string leaderboard_publicKey
// 3rd param: string achivemnet_publicKey
// return: return sdk_result_code
FREObject Init(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	// check number of arguments
	if (argc < 4)
		return FREInt(RESULT_DEVELOPER_ERROR);

	// read arguments
	std::string tmpPackageName, inAppPurchasePublicKey, leaderboard_publicKey, achivemnet_publicKey;
	bool isOk = FREGetString(argv[0], tmpPackageName);
	isOk = isOk && (FREGetString(argv[1], inAppPurchasePublicKey));
	isOk = isOk && (FREGetString(argv[2], leaderboard_publicKey));
	isOk = isOk && (FREGetString(argv[3], achivemnet_publicKey));

	if(!isOk)
		return FREInt(RESULT_DEVELOPER_ERROR);

	char *cstr = new char[tmpPackageName.length() + 1];
	strcpy(cstr, tmpPackageName.c_str());
	int initResult = Api_Init(cstr);
	delete[] cstr;
	if (initResult == RESULT_OK) 
	{
		// save packageName
		packageName = tmpPackageName;

		// init iabHelper
		if (!inAppPurchasePublicKey.empty())
		{
			char *c_iabPublickKey = new char[inAppPurchasePublicKey.length() + 1];
			strcpy(c_iabPublickKey, inAppPurchasePublicKey.c_str());

			initResult = ArioIabHelper_StartSetup(c_iabPublickKey);
			delete[] c_iabPublickKey;

			if (initResult != RESULT_OK)
			{
				return FREInt(initResult);
			}
		}
		// init leaderboard
		if (!leaderboard_publicKey.empty())
		{
			char *c_leaderboardKey = new char[leaderboard_publicKey.length() + 1];
			strcpy(c_leaderboardKey, leaderboard_publicKey.c_str());

			initResult = ArioLeaderboard_StartSetup(c_leaderboardKey);
			delete[] c_leaderboardKey;

			if (initResult != RESULT_OK)
			{
				return FREInt(initResult);
			}
		}
		// init achievement
		if (!achivemnet_publicKey.empty())
		{
			char* c_achievementKey = new char[achivemnet_publicKey.length() + 1];
			strcpy(c_achievementKey, achivemnet_publicKey.c_str());

			initResult = ArioAchievement_StartSetup(c_achievementKey);
			delete[] c_achievementKey;

			if (initResult != RESULT_OK)
			{
				return FREInt(initResult);
			}
		}
	}
	return FREInt(initResult);

}

FREObject IsLogin(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	bool isOk = ArioUser_IsLogin();
	return FREBool(isOk);
}
FREObject GetUserId(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	uint32_t result = ArioUser_GetId();
	return FREUint(result);
}

FREObject GetAvatarId(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	uint32_t result = ArioUser_GetAvatarId();
	return FREUint(result);
}

FREObject GetLevel(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	int result = ArioUser_GetLevel();
	return FREInt(result);
}

FREObject GetProfile(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	if (argc < 1)
	{
		return FREInt(RESULT_DEVELOPER_ERROR);
	}
		
	std::string reqCode;
	bool isOk = FREGetString(argv[0],reqCode);

	std::thread mahta([](int req_code) {
		ArioUser_GetProfile(req_code, JsonCallback);
	}, std::stoi(reqCode));
	mahta.detach();

	return FREInt(RESULT_OK);
}

FREObject CheckPurchase(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	if(packageName.empty()) // it means developer not invoke init function yet.
		return FREString(std::to_string(RESULT_GAME_NOT_RUN_FROM_ARIO));
	
	// copy packageName to char*
	char *cstr = new char[packageName.length() + 1];
	strcpy(cstr, packageName.c_str());
	
	char* purchaseToken;
	int lockResult = ValidatePurchase(cstr, &purchaseToken);
	delete[] cstr;

	int arioResult = ConvertLockResult2ArioResult(lockResult);

	if (arioResult == RESULT_OK)
	{
		std::string token = std::string(purchaseToken);
		return FREString(token);
	}
	else
	{
		return FREString(std::to_string(arioResult));
	}
}

FREObject CheckPurchaseAsynch(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	// check if developer send the request code!
	if (argc < 1)
	{
		return FREInt(RESULT_DEVELOPER_ERROR);
	}
	// get request code 
	std::string reqCode;
	bool isOk = FREGetString(argv[0], reqCode);
	if (!isOk)
		return FREInt(RESULT_DEVELOPER_ERROR);

	// check package name
	if (packageName.empty()) // it means developer not invoke init function yet.
		return FREInt(RESULT_GAME_NOT_RUN_FROM_ARIO);

	// using thread make this code asynchronous
	std::thread mahta([=](int req_code) {

		// copy packageName to char*
		char *cstr = new char[packageName.length() + 1];
		strcpy(cstr, packageName.c_str());

		// calling SDL function
		int initialLockResult = ValidatePurchaseAsyncStd(cstr, req_code, [](int requestCode, char* pszOrderId, int resultCode) {
			
			// this callback return when asynchronous function from SDK returns

			int finalLockResult = ConvertLockResult2ArioResult(resultCode);

			FREResult airResult;
			char eventCode[32];
			snprintf(eventCode, sizeof(eventCode), "%d", requestCode);
			char response[512];

			if (finalLockResult == RESULT_OK)
				sprintf(response, "{\"result\":%d , \"purchase_token\":\"%s\" }", finalLockResult, pszOrderId);
			else
				sprintf(response, "{\"result\":%d , \"purchase_token\":\"%s\" }", finalLockResult, "");

			// dispatch event
			airResult = FREDispatchStatusEventAsync(AIRContext,
				(const uint8_t*)eventCode, (const uint8_t*)response);

		});
		delete[] cstr;

		int arioResult = ConvertLockResult2ArioResult(initialLockResult);
		// Checking initial lock result
		if (arioResult != RESULT_OK)
		{
			FREResult airResult;
			char eventCode[32];
			snprintf(eventCode, sizeof(eventCode), "%d", req_code);
			char response[32];
			sprintf(response, "{\"result\":%d , \"purchase_token\":\"%s\" }", arioResult, "");
			// dispatch the error response 
			airResult = FREDispatchStatusEventAsync(AIRContext,
				(const uint8_t*)eventCode, (const uint8_t*)response);
		}
		else // initial call is ok, do nothing. the callback will handle the response.
		{
			;
		}
	}, std::stoi(reqCode));

	mahta.detach();

	return FREInt(RESULT_OK);
}

FREObject GetSkuDetails(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	if (argc < 2)
	{
		return FREInt(RESULT_DEVELOPER_ERROR);
	}

	std::string reqCode, skuList;
	bool isOk = FREGetString(argv[0], skuList);
	isOk = isOk && FREGetString(argv[1], reqCode);
	
	if(!isOk)
		return FREInt(RESULT_DEVELOPER_ERROR);

	std::thread mahta([=](int req_code) {

		// copy skuList to char*
		char *c_skuList = new char[skuList.length() + 1];
		strcpy(c_skuList, skuList.c_str());

		ArioIabHelper_GetSkuDetails(c_skuList, req_code, JsonCallback);
		delete[] c_skuList;

	}, std::stoi(reqCode));
	mahta.detach();

	return FREInt(RESULT_OK);
}

FREObject Buy(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	if (argc < 3)
	{
		return FREInt(RESULT_DEVELOPER_ERROR);
	}

	std::string sku, developerPayload, reqCode;
	bool isOk = FREGetString(argv[0], sku);
	isOk = isOk && FREGetString(argv[1], developerPayload);
	isOk = isOk && FREGetString(argv[2], reqCode);

	if (!isOk)
		return FREInt(RESULT_DEVELOPER_ERROR);

	std::thread mahta([=](int req_code) {

		// copy sku and developerPayload to char*
		char *c_sku = new char[sku.length() + 1];
		strcpy(c_sku, sku.c_str());

		char *c_payload = new char[developerPayload.length() + 1];
		strcpy(c_payload, developerPayload.c_str());

		ArioIabHelper_LaunchPurchaseFlow(c_sku, SKU_TYPE, c_payload, req_code, JsonCallback);
		delete[] c_sku;
		delete[] c_payload;

	}, std::stoi(reqCode));
	mahta.detach();

	return FREInt(RESULT_OK);
}

FREObject Consume(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	if (argc < 2)
	{
		return FREInt(RESULT_DEVELOPER_ERROR);
	}

	std::string purchaseToken, reqCode;
	bool isOk = FREGetString(argv[0], purchaseToken);
	isOk = isOk && FREGetString(argv[1], reqCode);

	if (!isOk)
		return FREInt(RESULT_DEVELOPER_ERROR);

	std::thread mahta([=](int req_code) {

		// copy purchaseToken to char*
		char *c_purchaseToken = new char[purchaseToken.length() + 1];
		strcpy(c_purchaseToken, purchaseToken.c_str());

		ArioIabHelper_Cunsume(c_purchaseToken, req_code, JsonCallback);
		delete[] c_purchaseToken;

	}, std::stoi(reqCode));
	mahta.detach();

	return FREInt(RESULT_OK);
}

FREObject GetInventory(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	if (argc < 1)
	{
		return FREInt(RESULT_DEVELOPER_ERROR);
	}

	std::string reqCode;
	bool isOk = FREGetString(argv[0], reqCode);

	if (!isOk)
		return FREInt(RESULT_DEVELOPER_ERROR);

	std::thread mahta([=](int req_code) {
		ArioIabHelper_GetInventory(SKU_TYPE, req_code, JsonCallback);
	}, std::stoi(reqCode));
	mahta.detach();

	return FREInt(RESULT_OK);
}

FREObject GetLeaderboards(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	if (argc < 1)
	{
		return FREInt(RESULT_DEVELOPER_ERROR);
	}

	std::string reqCode;
	bool isOk = FREGetString(argv[0], reqCode);

	if (!isOk)
		return FREInt(RESULT_DEVELOPER_ERROR);

	std::thread mahta([=](int req_code) {
		ArioLeaderboard_GetLeaderboards(req_code, JsonCallback);
	}, std::stoi(reqCode));
	mahta.detach();

	return FREInt(RESULT_OK);
}

FREObject GetScores(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	if (argc < 6)
	{
		return FREInt(RESULT_DEVELOPER_ERROR);
	}

	int leaderboardId, collectionType, timeFrame, offse, limit;
	std::string  reqCode;
	bool isOk = FREGetInt32(argv[0], &leaderboardId);
	isOk = isOk && FREGetInt32(argv[1], &collectionType);
	isOk = isOk && FREGetInt32(argv[2], &timeFrame);
	isOk = isOk && FREGetInt32(argv[3], &offse);
	isOk = isOk && FREGetInt32(argv[4], &limit);
	isOk = isOk && FREGetString(argv[5], reqCode);

	if (!isOk)
		return FREInt(RESULT_DEVELOPER_ERROR);

	std::thread mahta([=](int req_code) {
		ArioLeaderboard_GetScores(leaderboardId, collectionType, timeFrame, offse, limit, req_code, JsonCallback);

	}, std::stoi(reqCode));
	mahta.detach();

	return FREInt(RESULT_OK);
}

FREObject GetMyRank(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	if (argc < 6)
	{
		return FREInt(RESULT_DEVELOPER_ERROR);
	}

	int leaderboardId, collectionType, timeFrame, upLimit, downLimit;
	std::string  reqCode;
	bool isOk = FREGetInt32(argv[0], &leaderboardId);
	isOk = isOk && FREGetInt32(argv[1], &collectionType);
	isOk = isOk && FREGetInt32(argv[2], &timeFrame);
	isOk = isOk && FREGetInt32(argv[3], &upLimit);
	isOk = isOk && FREGetInt32(argv[4], &downLimit);
	isOk = isOk && FREGetString(argv[5], reqCode);

	if (!isOk)
		return FREInt(RESULT_DEVELOPER_ERROR);

	std::thread mahta([=](int req_code) {
		ArioLeaderboard_GetMyRank(leaderboardId, collectionType, timeFrame, upLimit, downLimit, req_code, JsonCallback);

	}, std::stoi(reqCode));
	mahta.detach();

	return FREInt(RESULT_OK);
}

FREObject SubmitScore(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	if (argc < 4)
	{
		return FREInt(RESULT_DEVELOPER_ERROR);
	}

	int leaderboardId, value;
	std::string  metadata, reqCode;
	bool isOk = FREGetInt32(argv[0], &value);
	isOk = isOk && FREGetInt32(argv[1], &leaderboardId);
	isOk = isOk && FREGetString(argv[2], metadata);
	isOk = isOk && FREGetString(argv[3], reqCode);

	if (!isOk)
		return FREInt(RESULT_DEVELOPER_ERROR);

	std::thread mahta([=](int req_code) {

		// copy metadata to char*
		char *c_metadata = new char[metadata.length() + 1];
		strcpy(c_metadata, metadata.c_str());
		ArioLeaderboard_SubmitScore(value, leaderboardId, c_metadata, req_code, JsonCallback);

	}, std::stoi(reqCode));
	mahta.detach();

	return FREInt(RESULT_OK);
}

FREObject ShowLeaderboard(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	ArioLeaderboard_ShowLeaderboards();
	// dummy return value
	return FREObject();
}

int ConvertLockResult2ArioResult(int lockResult)
{
	switch (lockResult)
	{

	case STORE_ERROR_CODE_OK:
		return RESULT_OK;
	case STORE_ERROR_KEY_NOT_FOUND:
	{
		return RESULT_GAME_NOT_OWNED;
		//sprintf(response, "{\"result\":%d , \"purchase_token\":\"%s\" }", RESULT_GAME_NOT_OWNED, "");
		//break;
	}
	case STORE_ERROR_INVALID_PACKAGE_NAME:
	case STORE_ERROR_INVALID_PARAM:
	case STORE_ERROR_NOT_RUN_FROM_ARIO:
	{
		return RESULT_GAME_NOT_RUN_FROM_ARIO;
// 		sprintf(response, "{\"result\":%d , \"purchase_token\":\"%s\" }", RESULT_GAME_NOT_RUN_FROM_ARIO, "");
// 		break;
	}
	case STORE_ERROR_UNKNWOWN:
	{
		return RESULT_ERROR;
// 		sprintf(response, "{\"result\":%d , \"purchase_token\":\"%s\" }", RESULT_ERROR, "");
// 		break;
	}
	default:
		return RESULT_ERROR;
// 		sprintf(response, "{\"result\":%d , \"purchase_token\":\"%s\" }", RESULT_ERROR, "");
// 		break;
	}
}

// A native context instance is created
void ArioContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functionsToSet)
{
	// I just do the things just as steam do :)
	AIRContext = ctx;
	// 	*functions = func;
	// 	*numFunctions = sizeof(func) / sizeof(func[0]);


	*numFunctions = 17;

	FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * (*numFunctions)); // * * :))))))

	// TODO @Mostafa88: generate this part with macro
	func[0].name = (const uint8_t*)"Init";
	func[0].functionData = NULL;
	func[0].function = &Init;

	func[1].name = (const uint8_t*)"IsLogin";
	func[1].functionData = NULL;
	func[1].function = &IsLogin;

	func[2].name = (const uint8_t*)"GetUserId";
	func[2].functionData = NULL;
	func[2].function = &GetUserId;

	func[3].name = (const uint8_t*)"GetAvatarId";
	func[3].functionData = NULL;
	func[3].function = &GetAvatarId;

	func[4].name = (const uint8_t*)"GetLevel";
	func[4].functionData = NULL;
	func[4].function = &GetLevel;

	func[5].name = (const uint8_t*)"GetProfile";
	func[5].functionData = NULL;
	func[5].function = &GetProfile;

	func[6].name = (const uint8_t*)"CheckPurchase";
	func[6].functionData = NULL;
	func[6].function = &CheckPurchase;

	func[7].name = (const uint8_t*)"CheckPurchaseAsynch";
	func[7].functionData = NULL;
	func[7].function = &CheckPurchaseAsynch;

	func[8].name = (const uint8_t*)"GetSkuDetails";
	func[8].functionData = NULL;
	func[8].function = &GetSkuDetails;

	func[9].name = (const uint8_t*)"Buy";
	func[9].functionData = NULL;
	func[9].function = &Buy;

	func[10].name = (const uint8_t*)"Consume";
	func[10].functionData = NULL;
	func[10].function = &Consume;

	func[11].name = (const uint8_t*)"GetInventory";
	func[11].functionData = NULL;
	func[11].function = &GetInventory;

	func[12].name = (const uint8_t*)"GetLeaderboards";
	func[12].functionData = NULL;
	func[12].function = &GetLeaderboards;

	func[13].name = (const uint8_t*)"GetScores";
	func[13].functionData = NULL;
	func[13].function = &GetScores;

	func[14].name = (const uint8_t*)"GetMyRank";
	func[14].functionData = NULL;
	func[14].function = &GetMyRank;

	func[15].name = (const uint8_t*)"SubmitScore";
	func[15].functionData = NULL;
	func[15].function = &SubmitScore;

	func[16].name = (const uint8_t*)"ShowLeaderboard";
	func[16].functionData = NULL;
	func[16].function = &ShowLeaderboard;

	*functionsToSet = func;
	//MessageBox(NULL, L"ContextInitializer", L"caption", 0);

}
// A native context instance is disposed
void ArioContextFinalizer(FREContext ctx)
{
	AIRContext = NULL;
	//MessageBox(NULL, L"ContextFinalizer", L"caption", 0);
	// Shutdown Steam
	// SteamAPI_Shutdown();
	// 	// Delete the SteamAchievements object
	// 	delete g_Steam;
	// 	g_Steam = NULL;
}

extern "C" {
	// Initialization function of each extension
	EXPORT void ArioExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
	{
		*extDataToSet = NULL;  // This example does not use any extension data. 
		*ctxInitializerToSet = &ArioContextInitializer;
		*ctxFinalizerToSet = &ArioContextFinalizer;
	}

	// Called when extension is unloaded
	EXPORT void ArioExtensionFinalizer(void* extData)
	{
		MessageBox(NULL, L"ExtensionFinalizer", L"caption", 0);
		return;
	}
}



