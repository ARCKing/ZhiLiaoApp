//
//  ResetPasswordViewController.m
//  NewApp
//
//  Created by gxtc on 17/2/15.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@property (weak, nonatomic) IBOutlet UIButton *DXmessageButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *DXfield;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;

@property (nonatomic,copy)NSString * phone;
@property (nonatomic,copy)NSString * DX;
@property (nonatomic,copy)NSString * passWord;

@property (assign,nonatomic)NSInteger  timeCount;
@property (strong,nonatomic)NSTimer * btTime;
@property (strong,nonatomic)UILabel * messageLabel;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeCount =0;
    
    [self showTheBlackMessageAleterNewWithFram:CGRectMake(ScreenWith/2 - 50, -30, 100, 30)];
}

- (IBAction)popButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



//倒计时

- (void)addTimeNew{
    
    if (self.btTime == nil) {
        self.btTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeBtTitle) userInfo:nil repeats:YES];
        self.timeCount = 60;
    }
    
}


- (void)changeBtTitle{
    
    [self.DXmessageButton setTitle:[NSString stringWithFormat:@"%ldS",self.timeCount--] forState:UIControlStateNormal];
    
    if (self.timeCount == 0) {
        
        [self stopTimes];
        
        [self.DXmessageButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}


- (void)stopTimes{
    [self.btTime invalidate];
    self.btTime = nil;
    
    self.DXmessageButton.backgroundColor = [UIColor greenColor];
    self.DXmessageButton.enabled = YES;
}


//黑色提示框====
- (void)showTheBlackMessageAleterNewWithFram:(CGRect)fram{
    
    self.messageLabel =  [self addRootLabelWithfram:fram andTitleColor:[UIColor whiteColor] andFont: 12 andBackGroundColor:[UIColor blackColor] andTitle:@"Message"];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.messageLabel];
}


- (void)showTheBlackMessageAlter:(NSString *)message{
    
    self.messageLabel.text = message;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.messageLabel.frame = CGRectMake(ScreenWith/2 - 50, 64, 100, 30);
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(dissmissMessageAleart) withObject:nil afterDelay:1.5];
        
    }];
}

- (void)dissmissMessageAleart{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.messageLabel.frame = CGRectMake(ScreenWith/2 - 50, -30, 100, 30);
        
    }];
}

//==========
- (void)enterButtonCanEnable{
    
    
    if (self.phone.length == 11 && self.DX.length >= 4 && self.passWord.length >=6) {
        
        self.enterButton.backgroundColor =[ UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
        self.enterButton.enabled = YES;
        
    }else{
        
        self.enterButton.backgroundColor =[ UIColor lightGrayColor];
        self.enterButton.enabled = NO;
    }
    
    
}

#pragma mark- buttonAction
- (IBAction)DXmessageButtonAction:(id)sender {
    NSLog(@"获取验证码!");
    NetWork *net = [NetWork shareNetWorkNew];
    
    [net getDXWithPhone:self.phone andType:1];
    __weak ResetPasswordViewController * weakSelf = self;
    
    net.findPassWordDXmessageBK=^(NSString * code,NSString * message){
        
        [weakSelf showTheBlackMessageAlter:message];
        
        
        if ([code isEqualToString:@"1"]) {
            
            
            weakSelf.DXmessageButton.backgroundColor = [UIColor lightGrayColor];
            weakSelf.DXmessageButton.enabled = NO;
            [weakSelf addTimeNew];
        }
        
    };

}

- (IBAction)sureButtonAction:(id)sender {
    NSLog(@"确定按钮!");
    [self outOfFistRespond];
    NetWork *net = [NetWork shareNetWorkNew];
    
    [net findBackUserWithPhone:self.phone andDXstring:self.DX andPassword:self.passWord];
    
    __weak ResetPasswordViewController * weakSelf = self;
    
    net.findBackPassWordBK = ^(NSString * code,NSString * message){
        
        if ([code isEqualToString:@"1"]) {
            
            [weakSelf showTheBlackMessageAlter:message];
            
            [weakSelf performSelector:@selector(popVC) withObject:nil afterDelay:1.7];
            
        }else{
            
            [weakSelf showTheBlackMessageAlter:message];
        }
        
    };
    

    
    
}

- (void)popVC{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- textField
- (IBAction)phoneNumberEditingDidEnd:(id)sender {
    NSLog(@"手机号码输入结束!");
    self.phone = self.phoneField.text;

}

- (IBAction)DXmessageEditingDidEnd:(id)sender {
    NSLog(@"短信验证码输入结束!");
    self.DX = self.DXfield.text;

}

- (IBAction)passWorldEditingDidEnd:(id)sender {
    NSLog(@"密码输入结束!");
    self.passWord = self.passWordField.text;

}

- (IBAction)phoneDidChange:(id)sender {
    
    self.phone = self.phoneField.text;
    
    if (self.phone.length == 11 && self.timeCount < 1) {
        
        self.DXmessageButton.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
        self.DXmessageButton.enabled = YES;
    }else{
        
        self.DXmessageButton.backgroundColor = [UIColor lightGrayColor];
        self.DXmessageButton.enabled = NO;
        
    }

}
- (IBAction)DXdidChange:(id)sender {
    self.DX = self.DXfield.text;
    [self enterButtonCanEnable];

}

- (IBAction)passWordDidChange:(id)sender {
    self.passWord = self.passWordField.text;
    
    [self enterButtonCanEnable];
}


- (void)outOfFistRespond{

    [self.phoneField resignFirstResponder];
    [self.DXfield resignFirstResponder];
    [self.passWordField resignFirstResponder];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self outOfFistRespond];
}
@end
