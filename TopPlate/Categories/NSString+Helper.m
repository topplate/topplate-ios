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

-(BOOL)isOnlyWhiteSpaces {
    
    NSString *pattern = @"^\\s*$";
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *matches = [expression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    BOOL isOnlyWhitespace = matches.count;
    
    return isOnlyWhitespace;
}

-(NSString *)trimWhiteSpaces {
    
   return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
