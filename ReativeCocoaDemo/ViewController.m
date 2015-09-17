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
#import "SignInService.h"
#import "MainViewController.h"
@interface ViewController ()<RACProtocolTest>

@property (weak, nonatomic) IBOutlet UITextField *accounttTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (copy,nonatomic) NSString *name;
@property (nonatomic,strong) SignInService *signService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self labelDemo];
    [self btnEnabledDemo];
    [self delegateDemo];
    [self notificationDemo];
    [self KVODemo];
    [self textFieldDemo];
    [self btnDemo];
}

/**
 *  label文字跟着textFiled动
 */
- (void)labelDemo{
    RAC(self.label,text) = self.accounttTextFiled.rac_textSignal;
}

/**
 *  RAC按钮的enabled在2个文本框都有文字的时候才能点击
 */
- (void)btnEnabledDemo{
    
    __weak typeof(self) weakSelf = self;

    RACSignal *accountTextSignal = [self.accounttTextFiled.rac_textSignal map:^id(NSString *text) {
        return @(weakSelf.accounttTextFiled.text.length > 0);
    }];
    
    RACSignal *pwdTextSignal = [self.pwdTextField.rac_textSignal map:^id(id value) {
        return @(weakSelf.pwdTextField.text.length > 0);
    }];
    
    RACSignal *combineSignal = [RACSignal combineLatest:@[accountTextSignal,pwdTextSignal] reduce:^id(NSNumber *accountTextSignal,NSNumber *pwdTextSignal){
        return @(accountTextSignal.boolValue && pwdTextSignal.boolValue);
    }];
    
    [combineSignal subscribeNext:^(NSNumber *combineSignal) {
        weakSelf.textBtn.enabled = combineSignal.boolValue;
    }];
}

/**
 *  通知RACDemo
 */
- (void)notificationDemo{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NotificationTest" object:nil] subscribeNext:^(NSNotification *note) {
        NSLog(@"看下能收到不 %@",note);
    }];
}

/**
 *  代理RACDemo
 */
- (void)delegateDemo{
    RACSignal *programmerSignal = [self rac_signalForSelector:@selector(makeApp) fromProtocol:@protocol(RACProtocolTest)];
    [programmerSignal subscribeNext:^(id x) {
        NSLog(@"执行代理方法");
    }];
}

/**
 *  KVORACDemo
 */
- (void)KVODemo{
    __weak typeof(self) weakSelf = self;
    [RACObserve(self, name) subscribeNext:^(NSString *name) {
        weakSelf.label.text = name;
    }];
}

/**
 *  textFieldRACDemo
 */
- (void)textFieldDemo{
    __weak typeof(self) weakSelf = self;
    [[self.pwdTextField.rac_textSignal map:^id(NSString *text) {
        return @(text.length > 6);
    }] subscribeNext:^(NSNumber *normal) {
        weakSelf.pwdTextField.backgroundColor = normal.boolValue ? [UIColor whiteColor] : [UIColor lightGrayColor];
    }];
}

/**
 *  按钮点击事件
 */
- (void)btnDemo{
    [[[self.textBtn rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signInSignal];
    }] subscribeNext:^(NSNumber *success) {
        if (success.boolValue == NO){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入的账号或者密码有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        MainViewController *mainVC = [[MainViewController alloc] init];
        mainVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        UINavigationController *naivVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
        [self presentViewController:naivVC animated:YES completion:nil];
    }];
}

/**
 *  创建登陆信号
 *
 */
- (RACSignal *)signInSignal{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       [self.signService signInWithAccount:self.accounttTextFiled.text password:self.pwdTextField.text completed:^(BOOL success) {
           [subscriber sendNext:@(success)];
           [subscriber sendCompleted];
       }];
        return nil;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationTest" object:@(NO)];
    static NSInteger index = 0;
    self.name = [NSString stringWithFormat:@"%tu",++index];
}

- (void)dealloc{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (SignInService *)signService{
    if (_signService == nil){
        _signService = [[SignInService alloc] init];
    }
    return _signService;
}

@end
