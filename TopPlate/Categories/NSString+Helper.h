//
//  NSString+Helper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/15/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)

-(NSURL *)withBaseUrl;

-(BOOL)containsString:(NSString *)str;

-(BOOL)isOnlyWhiteSpaces;

-(NSString *)trimWhiteSpaces;

-(NSString *)removeTexts:(NSArray<NSString *> *)texts;

@end
