//
//  NSString+MB.m
//  Florists
//
//  Created by Anil Khanna on 13/03/15.
//  Copyright (c) 2015 Anil Khanna. All rights reserved.
//

#import "NSString+MB.h"

@implementation NSString (MB)


- (NSString*)checkIfEmpty{
    
    if (!self || [self isKindOfClass:[NSNull class]] || self.length==0 || [self isEqualToString:@"<null>"] || [self isEqualToString:@"null"]) {
        return @"";
    }
    
    return self;
}

//- (NSString*)splitWith:(NSString*)character atIndex:(NSInteger)index{
//    NSArray *array = [self componentsSeparatedByString:character];
//    return ([array MB_safeObjectAtIndex:index]) ? :@"";
//}
//
//- (UIImage *)base64ToImage{
//    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
//    return [UIImage imageWithData:data];
//}

- (NSString*)base64{
    NSString *base64 = [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    return (base64)?:@"";
}

- (NSString*)base64ToString{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return (string)?:@"";
    
}

-(BOOL)hasSpace{

    NSArray *array = [self componentsSeparatedByString:@" "];
    return array.count>1;
}

- (NSRange)range{
    return NSMakeRange(0, self.length);
}



@end
