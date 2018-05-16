//
//  MacrosHelper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "MacrosHelper.h"

NSString * const kNotificationEnvironmentChange = @"Environment is changed.";
NSString * const kNotificationAddNewIngredient = @"Add new ingredient.";

NSString *appVersion() {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@ build %@", version, build];
}

NSString *appBuildVersion() {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@.%@", version, build];
}

NSString *pathToLogfile()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"logfile.txt"];
    return path;
}

void append(NSString *msg){
    // get path to Documents/somefile.txt
    NSString *path = pathToLogfile();
    // create if needed
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        fprintf(stderr,"Creating file at %s",[path UTF8String]);
        [[NSData data] writeToFile:path atomically:YES];
    }
    // append
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}

//void _Log(NSString *prefix, const char *file, int lineNumber, const char *funcName, NSString *format,...) {
//    va_list ap;
//    va_start (ap, format);
//    format = [format stringByAppendingString:@"\n"];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SS"];
//    
//    format = [NSString stringWithFormat:@"%@:  %@", [dateFormatter stringFromDate:[NSDate date]], format];
//    
//    NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:ap];
//    va_end (ap);
//    fprintf(stderr,"%s%50s:%3d - %s",[prefix UTF8String], funcName, lineNumber, [msg UTF8String]);
//    //fprintf(stderr,"%s", [msg UTF8String]);
//    
//    append(msg);
//}
