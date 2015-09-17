//
//  SignInService.m
//  ReativeCocoaDemo
//
//  Created by suning on 15/9/16.
//  Copyright (c) 2015年 gong. All rights reserved.
//

#import "SignInService.h"

@implementation SignInService

- (void)signInWithAccount:(NSString *)account password:(NSString *)password completed:(void (^)(BOOL success))completed{
    if ([account isEqualToString:@"norman"] && [password isEqualToString:@"123456"]){
        completed(YES);
        return;
    }
    completed(NO);
}

@end
