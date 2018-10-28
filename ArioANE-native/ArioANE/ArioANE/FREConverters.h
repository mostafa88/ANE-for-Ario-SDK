 /*
 *  FREConverters.cpp
 *  This file is part of FRESteamWorks.
 *
 *  Created by Ventero <http://github.com/Ventero> on 2014-04-09.
 *  Copyright (c) 2012-2014 Level Up Labs, LLC. All rights reserved.
 */
 
 #ifndef FRECONVERTERS_H
 #define FRECONVERTERS_H
 
 #include <string>
 #include <vector>
 
 #include <FlashRuntimeExtensions.h>
 // includes definitions of {u,}int{32,64}
 #include <cstdint>
 
 // Utility functions for conversion of FRE types
 FREObject FREBool(bool);
 FREObject FREDouble(double);
 FREObject FREInt(int32_t);
 FREObject FREUint(uint32_t);
 FREObject FREUint64(uint64_t);
 FREObject FREString(std::string);
 FREObject FREString(const char*);
 FREObject FREArray(uint32_t);
 FREObject FREBitmapDataFromImageRGBA(uint32_t width, uint32_t height, std::vector<uint8_t> const & argb_data);
 bool FREGetBool(FREObject object, bool* val);
 bool FREGetDouble(FREObject, double* val);
 bool FREGetInt32(FREObject, int32_t* val);
 bool FREGetUint32(FREObject, uint32_t* val);
 bool FREGetUint64(FREObject, uint64_t* val);
 bool FREGetString(FREObject, std::string& val);
 bool FREGetStringP(FREObject, std::string* val);
 
 // Extracts a std::vector<T> out of an FREObject array.
 // The converter function is one of the FREGet* functions above.
 template<typename T, typename Converter>
 std::vector<T> getArray(FREObject object, Converter conv) {
 	std::vector<T> ret;
 
 	uint32_t arrayLength;
 	if (FREGetArrayLength(object, &arrayLength) != FRE_OK)
 		return ret;
 
 	if (!arrayLength)
 		return ret;
 
 	ret.reserve(arrayLength);
 	for (uint32_t i = 0; i < arrayLength; ++i) {
 		FREObject value;
 		if (FREGetArrayElementAt(object, i, &value) != FRE_OK)
 			continue;
 
 		T val;
 		if (!conv(value, &val))
 			continue;
 
 		ret.push_back(val);
 	}
 
 	return ret;
 }
 
 // Commonly used alias to extract a string array.
 std::vector<std::string> extractStringArray(FREObject object);
 
 #endif