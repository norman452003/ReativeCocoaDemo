//
//  ViewController.m
//  ReativeCocoaDemo
//
//  Created by 龚欣 on 15/8/19.
//  Copyright (c) 2015年 gong. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RACEXTScope.h>
@interface ViewController ()<RACProtocolTest>

@property (weak, nonatomic) IBOutlet UITextField *accounttTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (nonatomic,copy) NSString *name;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,copy) NSString *name1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
//    [self.textFiled.rac_textSignal subscribeNext:^(NSString *text) {
//        weakSelf.textBtn.enabled = text.length > 0;
//    }];
    
//   [self.textFiled.rac_textSignal subscribeNext:^(NSString *text) {
//       NSLog(@"%tu",text.length);
//   }];
//    [[self.textFiled.rac_textSignal filter:^BOOL(NSString *value) {
//        NSString *text = value;
//        return text.length > 3;
//    }]
//    subscribeNext:^(NSString *text) {
//        
//    }];
    RACSignal *textFieldSignal = self.accounttTextFiled.rac_textSignal;
    RACSignal *filterUserName = [textFieldSignal filter:^BOOL(NSString *value) {
        return value.length > 3;
    }];
//    [filterUserName subscribeNext:^(NSString *text) {
//        NSLog(@"%@",text);
//    }];
//    [[self.textFiled.rac_textSignal filter:^BOOL(NSString *text) {
//        return text.length > 3;
//    }] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
//    __weak typeof(self) weakSelf = self;
//    [[self.textFiled.rac_textSignal map:^id(NSString *text) {
//        return @(text.length > 3);
//    }]  subscribeNext:^(NSNumber *value) {
//        weakSelf.textFiled.backgroundColor = value.boolValue ? [UIColor grayColor] : [UIColor blueColor];
//    }];
//  
//    [RACObserve(self, name) subscribeNext: ^(NSString *newName){
//        NSLog(@"newName:%@", newName);
//    }];
    
//    RAC(self.textBtn,enabled) = [RACSignal combineLatest:@[self.accounttTextFiled.rac_textSignal,self.pwdTextField.rac_textSignal] reduce:^(NSString *accountText,NSString *pwdText){
//        return nil;
//        }];
    
//    RAC(self.label,text) = RACObserve(self, name);
//    [RACObserve(self, name) subscribeNext:^(NSString *name) {
//        weakSelf.label.text = name;
//    }];
//    RAC(self.label,text) = [[[self.accounttTextFiled.rac_textSignal startWith:@"请输入3~10个字符"] filter:^BOOL(NSString *text) {
//        return text.length > 3;
//    }] map:^id(id value) {
//        return [value isEqualToString:@"norman"] ? @"right" : @"false";
//    }];
    
//    [[self.accounttTextFiled.rac_textSignal filter:^BOOL(NSString *text) {
//        return [text hasPrefix:@"123"];
//    }] subscribeNext:^(NSString *text) {
//        NSLog(@"%@",text);
//    }];
//    [self.accounttTextFiled.rac_textSignal subscribeNext:^(NSString *text) {
//        weakSelf.textBtn.enabled = text.length;
//    }];
    
    //代理
    RACSignal *programmerSignal = [self rac_signalForSelector:@selector(makeApp) fromProtocol:@protocol(RACProtocolTest)];
    [programmerSignal subscribeNext:^(id x) {
        NSLog(@"执行代理方法");
    }];
    //通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NotificationTest" object:nil] subscribeNext:^(NSNotification *note) {
        NSLog(@"看下能收到不 %@",note);
    }];

    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"第一步"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"第二步"];
        [subscriber sendCompleted];
        return nil;
    }];
    
//    [[signalA concat:signalB] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    [[RACSignal merge:@[signalB,signalB,signalA,signalA]] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationTest" object:@"传递"];
//}

- (void)dealloc{
    NSLog(@"dealloc");
}

@end
