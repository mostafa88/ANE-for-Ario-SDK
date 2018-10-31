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
#include <flat/flat_ario_user.h>
#include <sdk_result_code.h>
// Ario Lock headers
#include <StoreSdkCommon.h>
#endif // ARIO_SDK

//internal headers
#include "FREConverters.h"

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
	if (initResult == RESULT_OK) // save packageName
		packageName = tmpPackageName;

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


	*numFunctions = 8;

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



