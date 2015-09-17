//
//  SignInService.h
//  ReativeCocoaDemo
//
//  Created by suning on 15/9/16.
//  Copyright (c) 2015年 gong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInService : NSObject

- (void)signInWithAccount:(NSString *)account password:(NSString *)password completed:(void(^)(BOOL success))completed;

@end
