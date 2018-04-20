//
//  NSString+Helper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/15/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

-(NSURL *)withBaseUrl {
    
   return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseAPIUrl, self]];
}

-(BOOL)containsString:(NSString *)str {
    NSRange range = [self rangeOfString:str];
    BOOL contains = (range.location != NSNotFound);
    return contains;
}

@end
