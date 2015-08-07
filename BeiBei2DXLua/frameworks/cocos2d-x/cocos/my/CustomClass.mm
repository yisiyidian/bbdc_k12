// CustomClass.cpp
#include "CustomClass.h"

USING_NS_CC;

CustomClass::CustomClass(){

}

CustomClass::~CustomClass(){

}

bool CustomClass::init(){
    return true;
}

std::string CustomClass::addSkipBackupAttributeToItemAtPath(std::string s) {

    #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) 
    	//iOS代码 
		NSString *str= [NSString stringWithCString:s.c_str() encoding:[NSString defaultCStringEncoding]];
    	NSURL* URL= [NSURL fileURLWithPath: str];
	    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
	 
	    NSError *error = nil;
	    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
	                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
	    if(!success){
	        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
	    }
	    if (success){
	    	return "ios: add attribute 'do not back up' successfully to target folder (" + s + ")";
	    }
	    else{
	    	return "ios: add attribute 'do not back up' fail to target folder (" + s + ")";
	    }
	#else 
	    //Android代码 
	#endif

	return "not ios: no need to add attribute 'do not back up' to target folder (" + s + ")";

}
