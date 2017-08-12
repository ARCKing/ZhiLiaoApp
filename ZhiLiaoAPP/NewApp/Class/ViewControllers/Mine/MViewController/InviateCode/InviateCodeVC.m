//
//  InviateCodeVC.m
//  NewApp
//
//  Created by gxtc on 17/2/22.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "InviateCodeVC.h"

@interface InviateCodeVC ()<UITextFieldDelegate>

@property (nonatomic,copy)NSString * inviateCode;
@property (nonatomic,strong)UITextField * field;

@property (nonatomic,strong)UIView * fiveView;

@property (nonatomic,strong)UIButton * inviateBt;


@property (nonatomic,copy)NSString * inviter;
@property (nonatomic,copy)NSString * url;

@end

@implementation InviateCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    [self addUI];
    
    [self inviateCodeAndlink];
    
}

- (void)addUI{
    [super addUI];
    
    self.titleLabel.text = @"输入邀请码";

    [self view1New];
    [self view2New];
}


- (void)view1New{

    UIView * view = [self InviateviewNew:CGRectMake(0, 64, ScreenWith, (ScreenHeight - 64 - 10)/3)];
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWith/6, ScreenWith/12, ScreenWith * 2/3, ScreenWith/6)];
    textField.backgroundColor = [UIColor orangeColor];
    textField.placeholder = @"请输入邀请码";
    textField.delegate = self;
    self.field = textField;
    
    [view addSubview:textField];
    UIButton * bt = [self buttonNewFram:CGRectMake(15, ((ScreenHeight - 64 - 10)/3) - 40 -ScreenWith/12, ScreenWith - 30, 35) andSel:@selector(buttonAction1) andTitle:@"提交邀请码"];
    [view addSubview:bt];
    
    [self.view addSubview:view];
}


- (void)view2New{
    UIView * view = [self InviateviewNew:CGRectMake(0, (ScreenHeight - 64 - 10)/3 + 10 + 64, ScreenWith, (ScreenHeight - 64 - 10) * 2 /3)];

    
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hongbao"]];
    image.frame = CGRectMake(0, 0, ScreenWith/6, ScreenWith/7);
    image.center = CGPointMake(ScreenWith/2, ScreenWith/5);
    [view addSubview:image];
    
    [self addLabelWithfram:CGRectMake(ScreenWith/6,CGRectGetMaxY(image.frame)+ 10, ScreenWith*2/3, 20) andtext:@"邀请好友，获得丰厚奖励" andColor:[UIColor orangeColor] andWithParentView:view];
    [self addLabelWithfram:CGRectMake(ScreenWith/6, CGRectGetMaxY(image.frame)+ 40, ScreenWith*2/3, 20) andtext:@"好友注册成功，2000金币奖励马上到账" andColor:[UIColor redColor] andWithParentView:view];
    [self addLabelWithfram:CGRectMake(ScreenWith/6, CGRectGetMaxY(image.frame)+ 70, ScreenWith*2/3, 20) andtext:@"好友阅读文章，您坐收双倍金币" andColor:[UIColor redColor] andWithParentView:view];
    UILabel * label =  [self addLabelWithfram:CGRectMake(ScreenWith/6, CGRectGetMaxY(image.frame)+ 100, ScreenWith*2/3, 20) andtext:@"好友分享文章，您将赚得20%收益" andColor:[UIColor redColor] andWithParentView:view];

    UIButton * bt =[self buttonNewFram:CGRectMake(15, CGRectGetMaxY(label.frame) + 20, ScreenWith - 30, 35) andSel:@selector(buttonAction2:) andTitle:@"邀请好友去赚钱"];
    self.inviateBt = bt;
    
    [view addSubview:bt];
    [self.view addSubview:view];

}



- (UILabel *)addLabelWithfram:(CGRect)fram andtext:(NSString *)text andColor:(UIColor *)color andWithParentView:(UIView *)view{
    UILabel * label = [[UILabel alloc]initWithFrame:fram];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = color;
    [view addSubview:label];
    return label;
}


- (UIView *)InviateviewNew:(CGRect)fram{

    UIView * view = [[UIView alloc]initWithFrame:fram];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    return  view;
}


- (UIButton *)buttonNewFram:(CGRect)fram andSel:(SEL)sel andTitle:(NSString *)title{

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = fram;
    button.backgroundColor = [UIColor colorWithRed:0.0 green:217.0/255.0 blue:1.0 alpha:1.0];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.layer.cornerRadius = fram.size.height/2;
    button.clipsToBounds = YES;
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];

    return button;
}


- (void)buttonAction1{

    NSLog(@"buttonAction1=%@",self.inviateCode);
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    [self.field resignFirstResponder];
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net iniateCodePushAndinviateCode:self.inviateCode];
    __weak InviateCodeVC * weakSelf = self;
    net.inviateCodePushBK=^(NSString * code,NSString * message){
    
        NSLog(@"%@%@",code,message);
        
        [hud hideAnimated:YES];
        
        [weakSelf rootShowMBPhudWith:message andShowTime:0.6];
        
    };
}


- (void)buttonAction2:(UIButton *)bt{
    NSLog(@"buttonAction2");

//    bt.enabled = NO;
    
    //    [self inviateButtonViewNew];
    
    
    InviateFriendTypeTwoVC * vc = [[InviateFriendTypeTwoVC alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    

}


- (void)inviateButtonViewNew{

    if (self.fiveView) {
        
        [self.view addSubview:self.fiveView];
        return;
    }
    
    NSArray * images = @[@"invite_link",@"invite_friend",@"invite_wechat",@"invite_zone",@"invite_qq"];
    NSArray * title = @[@"复制链接",@"发朋友圈",@"  发微信",@"发QQ空间",@"  发QQ"];
    
    UIView * fiveButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - ScreenWith/3, ScreenWith , ScreenWith/3)];
    fiveButtonView.backgroundColor = [UIColor whiteColor];
    
    fiveButtonView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    fiveButtonView.layer.shadowOpacity = 0.8;
    
    [self.view addSubview:fiveButtonView];
    self.fiveView = fiveButtonView;
    
    for (int i = 0; i < 5; i ++) {
        
        UIButton * button = [self addRootButtonTypeTwoNewFram:CGRectMake(( ScreenWith - ScreenWith/8 * 5)/6 + (( ScreenWith - ScreenWith/8 * 5)/6 + ScreenWith/8) * i, 10, ScreenWith/8, ScreenWith/8) andImageName:images[i] andTitle:@"" andBackGround:[UIColor clearColor] andTitleColor:[UIColor clearColor] andFont:17.0 andCornerRadius:0.0];
        button.tag = 2120 + i;
        
        [button addTarget:self action:@selector(fiveBtAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * label = [self addRootLabelWithfram:CGRectMake(CGRectGetMinX(button.frame) - 2, CGRectGetMaxY(button.frame) + 10, ScreenWith/5, 15) andTitleColor:[UIColor blackColor] andFont:13.0 andBackGroundColor:[UIColor clearColor] andTitle:title[i]];
        label.textAlignment = NSTextAlignmentLeft;
        [fiveButtonView addSubview:button];
        [fiveButtonView addSubview:label];

    }

    
    UIButton * cancleButton = [self addRootButtonTypeTwoNewFram:CGRectMake(30, ScreenWith/3 - ScreenWith/10, ScreenWith - 60, ScreenWith/11) andImageName:nil andTitle:@"取消" andBackGround:[UIColor blueColor] andTitleColor:[UIColor whiteColor] andFont:15.0 andCornerRadius:5.0];
    [cancleButton addTarget:self action:@selector(cancleBtAction) forControlEvents:UIControlEventTouchUpInside];

    [fiveButtonView addSubview:cancleButton];
}

- (void)cancleBtAction{

    self.inviateBt.enabled = YES;
    
    [self.fiveView removeFromSuperview];

}

#pragma mark- 五个按钮Action
- (void)fiveBtAction:(UIButton *)bt{
        
        if (bt.tag == 2120) {
            NSLog(@"复制链接");
            
            [self copyLink];
            
        }else if (bt.tag == 2121){
            NSLog(@"发朋友圈");
            
        }else if (bt.tag == 2122){
            NSLog(@"发微信");
            
        }else if (bt.tag == 2123){
            NSLog(@"发QZONE");
            
        }else if (bt.tag == 2124){
            NSLog(@"发QQ");
            
        }
    self.inviateBt.enabled = YES;
    [self.fiveView removeFromSuperview];

    
   
    
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{

    self.inviateCode = textField.text;
    NSLog(@"==>%@",textField.text);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.field resignFirstResponder];

}


- (void)copyLink{
    
    NSLog(@"复制分享链接");
    
    NSString * url = self.url;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = url;
    
    if (pasteboard.string != nil) {
        
        UIAlertController * alertControll = [UIAlertController alertControllerWithTitle:@"复制成功" message:nil preferredStyle: UIAlertControllerStyleAlert];
        
        [self presentViewController:alertControll animated:YES completion:^{
            
            NSLog(@"提示框来了!");
            
        }];
        
        [self performSelector:@selector(removeAlerateFromSuperView:) withObject:self afterDelay:1];
        
        
    }else {
        UIAlertController * alertControll = [UIAlertController alertControllerWithTitle:@"复制失败" message:nil preferredStyle: UIAlertControllerStyleAlert];
        
        [self presentViewController:alertControll animated:YES completion:^{
            
            NSLog(@"提示框来了!");
            
        }];
        
        [self performSelector:@selector(removeAlerateFromSuperView:) withObject:self afterDelay:1];
        
    }
    
}

//提示框消失
- (void)removeAlerateFromSuperView:(UIAlertController *)alertControll{
    
    [alertControll dismissViewControllerAnimated:YES completion:nil];
    
}


/**收徒链接*/
- (void)inviateCodeAndlink{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net mineInviateCodeAndInviateLink];
    
    __weak InviateCodeVC * weakSelf = self;
   
    net.mineInviateCodeAndInviteLinkBK=^(NSString * code,NSString * inviter,NSString * url,NSArray * arr1,NSArray * arr2){
    
        [hud hideAnimated:YES];
        
        if ([code isEqualToString:@"1"]) {
            
            weakSelf.inviter = inviter;
            weakSelf.url = url;
        }
    
    };
    
}


@end
