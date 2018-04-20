//
//  MacrosHelper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)

#pragma mark - Environment
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_SCALE [[UIScreen mainScreen] scale]

#define IS_SIMULATOR TARGET_IPHONE_SIMULATOR

#define IS_RETINA (SCREEN_SCALE > 1) ? YES : NO
#define IS_RETINA_3X (SCREEN_SCALE >= 3 ? YES : NO)

#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPAD_1 (IS_IPAD && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_X (SCREEN_HEIGHT == 812.0)
#define IS_IPHONE_6 (SCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6P (SCREEN_HEIGHT == 736.0)
#define IS_IPHONE_5 (SCREEN_HEIGHT == 568)
#define IS_IPHONE_4 (SCREEN_HEIGHT == 480)

#pragma mark - System Version
#define VERSION_GREATER_THAN(v1, v2)               ([v1 compare:v2 options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_EQUAL_TO(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_OS_9_OR_LATER     (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
#define IS_OS_8_OR_LATER     (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

#endif

#pragma mark - Logging


//#define NSLog(args...) _Log(@"DEBUG ", __FILE__,__LINE__,__PRETTY_FUNCTION__,args)

#ifdef DEBUG

//the same as NSLog
//#define DLog(args...) _Log(@"DEBUG ", __FILE__,__LINE__,__PRETTY_FUNCTION__,args)

//with class name
//#   define DLog(fmt, ...) NSLog((@"%s" fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);

//with class name and line number
//#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

//Shows in log time interval in ms betwen calls of SJG_MEASURE_START and SJG_MEASURE_STOP
#ifdef DEBUG
#define SJG_MEASURE_START CFAbsoluteTime _sjg_measure_time1 = CFAbsoluteTimeGetCurrent();
#else
#define SJG_MEASURE_START
#endif

#ifdef DEBUG
#define SJG_MEASURE_STOP CFAbsoluteTime _sjg_measure_time2 = CFAbsoluteTimeGetCurrent(); NSLog(@"%f.2 ms", (_sjg_measure_time2 - _sjg_measure_time1) * 1000);
#else
#define SJG_MEASURE_STOP
#endif


#define kConnectionError [NSString stringWithFormat:@"Connection error"]
#define kRetry [NSString stringWithFormat:@"Retry"]
#define kWarning [NSString stringWithFormat:@"Warning"]
#define kSuccess [NSString stringWithFormat:@"Success"]
#define kError [NSString stringWithFormat:@"Error"]


#pragma mark - User API data keys -

#define kUserName [NSString stringWithFormat:@"username"]
#define kUserId [NSString stringWithFormat:@"id"]
#define kCompany [NSString stringWithFormat:@"company"]
#define kEmail [NSString stringWithFormat:@"email"]
#define kPassword [NSString stringWithFormat:@"password"]
#define kUserCity [NSString stringWithFormat:@"city"]
#define kCountry [NSString stringWithFormat:@"country"]
#define kAddress [NSString stringWithFormat:@"address"]
#define kZip [NSString stringWithFormat:@"zip"]
#define kBusiness [NSString stringWithFormat:@"business"]
#define kPhone [NSString stringWithFormat:@"phone"]
#define kVat [NSString stringWithFormat:@"vat"]
#define kUserToken [NSString stringWithFormat:@"access-token"]
#define kUserRole [NSString stringWithFormat:@"role"]
#define kLimit [NSString stringWithFormat:@"limit"]
#define kDefaultLimitQuantity [NSString stringWithFormat:@"1000"]



#pragma mark - User local data keys -

#define kUserRememberMe [NSString stringWithFormat:@"rememberMe"]


#define kStoryboardNameLogin [NSString stringWithFormat:@"Login"]
#define kStoryboardNameMainLogics [NSString stringWithFormat:@"MainLogics"]
#define kRememberState [NSString stringWithFormat:@"RememberUserState"]

#pragma mark - Placeholders -

#define kUserNamePlaceholder [NSString stringWithFormat:@"Username"]
#define kCompanyPlaceholder [NSString stringWithFormat:@"Company name"]
#define kEmailPlaceholder [NSString stringWithFormat:@"E-mail"]
#define kPasswordPlacholder [NSString stringWithFormat:@"Password"]
#define kCountryPlaceholder [NSString stringWithFormat:@"Country"]
#define kAddressPlaceholder [NSString stringWithFormat:@"Address"]
#define kZipPlaceholder [NSString stringWithFormat:@"Zip code"]
#define kBusinessPlacehplder [NSString stringWithFormat:@"Business"]
#define kPhonePlaceholder [NSString stringWithFormat:@"Phone number"]
#define kVatPlaceholder [NSString stringWithFormat:@"Vat code"]
#define kCityPlaceholder [NSString stringWithFormat:@"City"]


#pragma mark - Model constants

#pragma mark Product


#pragma mark - Wish list -

#define kWishlistAttentionText [NSString stringWithFormat:@"Don’t forget we are wholesalers! We need to sell a variety of items, so we cannot make orders with only one or two different items. Please try to select a wide range of articles.The minimum order quantity is one pallet box, which can contain about 16 plastic bags or 400 kg of goods."]
#define kWishlistAttention [NSString stringWithFormat:@"Attention"]

void _Log(NSString * _Nullable prefix, const char * _Nullable file, int lineNumber, const char *_Nullable funcName, NSString *_Nullable format,...);

NSString * _Nonnull appVersion();
NSString * _Nonnull appBuildVersion();
NSString * _Nonnull pathToLogfile();
