//
//  ExchangeRecordCell.h
//  NewApp
//
//  Created by gxtc on 17/3/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootTableViewCell.h"
#import "withDrawCashRecordModel.h"

@interface ExchangeRecordCell : RootTableViewCell


@property(nonatomic,strong)withDrawCashRecordModel * model;

@property(nonatomic,strong)UILabel * reasonLabel;
@property(nonatomic,assign)BOOL isShow;
@property(nonatomic,strong)UIImageView * reasonImgView;

@end
