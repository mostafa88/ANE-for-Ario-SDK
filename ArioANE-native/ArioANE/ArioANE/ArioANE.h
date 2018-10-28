/*
*  ArioANE.h
*  This file is part of Ario AIR Native Extension (ANE) framwork.
*
*  Created by Mostafa Zamani on 2018-10-22
*  email: m.zamani@ariogames.ir
*  Based on FRESteamWroks project (https://github.com/Ventero/FRESteamWorks)
*  Copyright (c) 2018, All rights reserved for Ario.
*/
#ifndef __ARIO_ANE_H__
#define __ARIO_ANE_H__

#if defined(WIN32)
#define EXPORT __declspec(dllexport)
#else
// Symbols tagged with EXPORT are externally visible.
// Must use the -fvisibility=hidden gcc option.
#define EXPORT __attribute__((visibility("default")))
#endif

#include <string>

#include <FlashRuntimeExtensions.h>

static std::string packageName;

//// these functions set in ExtensionInitializer
void ArioContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functions);
void ArioContextFinalizer(FREContext ctx);

// extension functions
FREObject Init(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
// user functions
FREObject IsLogin(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject GetUserId(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject GetAvatarId(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject GetLevel(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject GetProfile(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);


// these function addressed in ANE "descriptor.xml" file
extern "C" {
	EXPORT void ArioExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
	EXPORT void ArioExtensionFinalizer(void* extData);

}



#endif // __ARIO_ANE_H__
