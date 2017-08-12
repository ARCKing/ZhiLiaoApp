//
//  NetWork.h
//  NewApp
//
//  Created by gxtc on 17/2/24.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^MessageFromNetComeBackBolck) (NSString *,NSString *);

typedef void(^DataFromNetComeBackBolck) (NSString *,NSString *,NSString *,NSArray * ,NSArray *);


@interface NetWork : NSObject

/**新用户注册Bolck*/
@property(nonatomic,copy)MessageFromNetComeBackBolck userRegisterBK;

/**用户登录Bolck*/
@property(nonatomic,copy)MessageFromNetComeBackBolck userLoginBK;

/**退出登录Bolck*/
@property(nonatomic,copy)MessageFromNetComeBackBolck outLoginBK;


/**获取短信Bolck*/
@property(nonatomic,copy)MessageFromNetComeBackBolck userDXmessageBK;

/**找回重置密码Bolck*/
@property(nonatomic,copy)MessageFromNetComeBackBolck findBackPassWordBK;

/**获取短信Bolck*/
@property(nonatomic,copy)MessageFromNetComeBackBolck findPassWordDXmessageBK;

/**上传头像Bolck*/
@property(nonatomic,copy)MessageFromNetComeBackBolck userIconUpLoadBK;


/**显示历史阅读Bolck*/
@property(nonatomic,copy)DataFromNetComeBackBolck historyArticleReadListBK ;


/**文章分类*/
@property(nonatomic,copy)DataFromNetComeBackBolck articleClassifyBK;

/**文章列表*/
@property(nonatomic,copy)DataFromNetComeBackBolck articleListBK;

/**视频列表*/
@property(nonatomic,copy)DataFromNetComeBackBolck videoListBK;

/**添加收藏Block*/
@property(nonatomic,copy)MessageFromNetComeBackBolck userAddCollectinBK;

/**取消收藏Block*/
@property(nonatomic,copy)MessageFromNetComeBackBolck userCancleCollectionBK;

/**是否收藏*/
@property(nonatomic,copy)DataFromNetComeBackBolck userIsOrNotCollectionBK;

/**显示收藏列表*/
@property(nonatomic,copy)DataFromNetComeBackBolck userArticleCollectionListBK;

/**验证Token*/
@property(nonatomic,copy)MessageFromNetComeBackBolck checkLoginTokenBK;

/**签到*/
@property(nonatomic,copy)DataFromNetComeBackBolck registerEveryDayBK;

/**任务中心*/
@property(nonatomic,copy)DataFromNetComeBackBolck testCenterBK;


/**支付宝提现金额*/
@property(nonatomic,copy)DataFromNetComeBackBolck aliPayCashBK;

/**支付宝提现申请*/
@property(nonatomic,copy)MessageFromNetComeBackBolck aliPayWithDrawOrderBK;

/**支付宝提现记录*/
@property(nonatomic,copy)DataFromNetComeBackBolck aliPayWithDrawRecordBK;

/**兑换记录*/
@property(nonatomic,copy)DataFromNetComeBackBolck exchangeRecordBK;

/**文章搜索*/
@property(nonatomic,copy)DataFromNetComeBackBolck searchArticleDataBK;

/**文章排行榜*/
@property(nonatomic,copy)DataFromNetComeBackBolck articleRankBK;

/**用户排行*/
@property(nonatomic,copy)DataFromNetComeBackBolck userRankBK;

/**个人主页*/
@property(nonatomic,copy)DataFromNetComeBackBolck personHomeBK;

/**回复，点赞，评论*/
@property(nonatomic,copy)MessageFromNetComeBackBolck commentBK;

/**评论列表*/
@property(nonatomic,copy)DataFromNetComeBackBolck commentListBK;

/**新手任务*/
@property(nonatomic,copy)DataFromNetComeBackBolck personNewTestBK;

/**领取新手奖励*/
@property(nonatomic,copy)MessageFromNetComeBackBolck personNewTestFinishBK;

/**我的数据*/
@property(nonatomic,copy)DataFromNetComeBackBolck mineDataSourceBK;

/**系统通知*/
@property(nonatomic,copy)DataFromNetComeBackBolck systemMessageDataBK;

/**系统通知详情*/
@property(nonatomic,copy)DataFromNetComeBackBolck systemMessageDetailBK;

@property(nonatomic,copy)DataFromNetComeBackBolck myRespondDataBK;
/**广告推广语*/
@property(nonatomic,copy)DataFromNetComeBackBolck advStringBK;

/**收益明细*/
@property(nonatomic,copy)DataFromNetComeBackBolck profitDetailBK;

/**关于我们*/
@property(nonatomic,copy)DataFromNetComeBackBolck aboutUsBK;


/**徒弟列表*/
@property(nonatomic,copy)DataFromNetComeBackBolck frientListBK;



/**收徒链接*/
@property(nonatomic,copy)DataFromNetComeBackBolck shouTuLinkMessageBK;


/**我的资料*/
@property(nonatomic,copy)DataFromNetComeBackBolck MineDetailDataBK;


/**修改我的资料*/
@property(nonatomic,copy)MessageFromNetComeBackBolck changeMineDataBK;


/**我的邀请码-邀请链接*/
@property(nonatomic,copy)DataFromNetComeBackBolck mineInviateCodeAndInviteLinkBK;


/**提交邀请码*/
@property(nonatomic,copy)MessageFromNetComeBackBolck inviateCodePushBK;


/**反馈列表*/
@property(nonatomic,copy)DataFromNetComeBackBolck respondListBK;

/**提交反馈*/
@property(nonatomic,copy)MessageFromNetComeBackBolck respondSendBk;

/**推送分享链接*/
@property(nonatomic,copy)DataFromNetComeBackBolck pushArticleShareAndSlinkBK;

/**高收益文章收益*/
@property(nonatomic,copy)MessageFromNetComeBackBolck getHeightPriceArticleMoneyBK;

/**版本更新*/
@property(nonatomic,copy)DataFromNetComeBackBolck checkNewVewsionBK;

/**自动跳转分享链接*/
@property(nonatomic,copy)DataFromNetComeBackBolck getAutonShareLinkBK;


/**QQ号链接获取*/
@property(nonatomic,copy)DataFromNetComeBackBolck QQnumberLinkGetBK;

/**审核隐藏BK*/
@property(nonatomic,copy)MessageFromNetComeBackBolck hidenWhenReviewBK;

//================================

/** 单例创建*/
+ (instancetype)shareNetWorkNew;

//================================


/**
 *注册新用户
 */
- (void)regisNewUserWithPhone:(NSString *)phone andDXstring:(NSString *)DX andPassword:(NSString *)passWord
                   andInviter:(NSString *)inviter andOpinId:(NSString *)openId
                   andAccessToken:(NSString *)accessToken;


/**
 *获取短信
 */
- (void)getDXWithPhone:(NSString *)phone andType:(NSInteger)type;

/**
 *用户登录
 */
- (void)userLoginWithPhone:(NSString *)phone andPassWord:(NSString *)passWord;


/**验证token*/
- (void)checkLoginToken;


/**
 *退出登录
 */
- (void)outOfLoginWithTokenAndUid;

/**
 *找回密码[重置密码]
 */
- (void)findBackUserWithPhone:(NSString *)phone andDXstring:(NSString *)DX andPassword:(NSString *)passWord;


/**
 *上传用户头像
 */
- (void)userIconUpLoadToPhp:(NSData *)data;


/**添加历史阅读*/
- (void)userHistoryRedAddArticleWithUidAndTokenAndID:(NSString *)Article_id andTitle:(NSString *)title;


/**显示历史阅读记录*/
- (void)userHistoryRedShowListWithUidAndToken;

/**清除历史记录*/
//- (void)clearUserHistoryRedRecoard;

/**文章分类*/
- (void)getArticleChannelClassifyFromNet;

/**文章列表*/
- (void)getArticleListFromNetWithC_id:(NSString * )c_id andPageIndex:(NSString *)pageIndex andUid:(NSString *)uid andType:(NSString *)type;

/**视频列表*/
- (void)getVideoListFromNetWithPage:(NSString *)page;


/**添加收藏*/
- (void)userAddCollectionArticleWithArticleAid:(NSString *)aid;

/**取消收藏*/
- (void)userCancleCollectionArticleWithArticleAid:(NSString *)aid;

/**显示收藏*/
- (void)userAllCollectionArticleList;

/**是否收藏*/
- (void)userIsOrNotCollectionArticleWithArticleAid:(NSString *)aid;

/**签到*/
- (void)userRegisterEveryDay;


/**任务中心数据请求*/
- (void)testCenterDataFromNet;


#pragma mark- 支付宝
/**支付宝提现金额*/
- (void)aliPayCashGetFromNet;

/**支付宝提现申请*/
- (void)aliPayCashOrderGetFromNetWithMoney:(NSString *)price andAliPayAccount:(NSString *)alipay
                                   andName:(NSString *)realname
                               andPassWord:(NSString *)password;



#pragma mark- 文章搜索
/**文章搜索*/
- (void)articleSearchGetDataFromNetWithTitle:(NSString *)title;


#pragma mark- 文章排行榜
/**文章排行榜*/
- (void)articleRankListGetDataWithType:(NSString *)type andPage:(NSInteger)page andC_id:(NSString *)c_id;


#pragma mark- 用户排行
/**用户排行*/
- (void)userRankListGetFromNetWithType:(NSString *)type andTime:(NSString * )time andPage:(NSInteger)page;


#pragma mark- 写评论或回复
/**评论回复点赞*/
- (void)writeCommentAndRespondWithTypr:(NSInteger)type
                            andContent:(NSString *)content
                                 andID:(NSString *)ID
                                andAID:(NSString *)aid
                           andRelation:(NSString *)relation
                            andRelname:(NSString *)relname;


#pragma mark-评论列表
/**评论列表*/
- (void)getCommentListDataFromNetWithAid:(NSString *)aid andPage:(NSInteger)page;


#pragma mark- 个人主页
/**个人主页*/
//类型 share 分享 comment 评论 colletion 收藏
- (void)personCenterDataGetFromNetWith:(NSInteger)page andType:(NSString *)type andUid:(NSString *)uid;
;


#pragma mark- 新手任务
/**新手任务*/
- (void)personNewTestStatue;


#pragma mark- 领取新手任务
/**领取新手任务*/
- (void)personNewTestFinish;

#pragma mark- 我的数据（用户中心）
/**我的*/
- (void)getMineDataSource;



#pragma mark-广告推广语
/**广告推广语*/
- (void)advStringGetDataFromNet;

#pragma mark- 我的回复
/**我的回复*/
- (void)getMyRespondDataFromNetWithPage:(NSInteger)page;


#pragma merk- 系统通知
/**系统通知*/
- (void)getSystemMessageFromNetWithPage:(NSInteger)page;

#pragma merk- 系统通知详情
/**系统通知详情*/
- (void)systemMessageDetailFromNetWithID:(NSString *)ID;


#pragma mark- 收益明细
/**收益明细*/
- (void)profitDetailFromNetWithPage:(NSInteger)page;


#pragma mark- 关于我们
/**关于我们*/

- (void)aboutUsMessageFromNet;


#pragma mark- 徒弟列表
/**徒弟列表*/
- (void)fiendListFromNetWithPage:(NSInteger)page;



#pragma mark- 兑换记录
/**兑换记录*/
//- (void)exchangeRecoardFromNetWith:(NSInteger)page;

#pragma mark- 提现记录
/**提现记录*/
- (void)AliPayWithDrawRecordWithPage:(NSInteger)page;


#pragma mark- 收徒链接
/**收徒链接*/
- (void)shouTuLinkMessageFromNet;


#pragma mark- 我的资料
/**我的资料*/
- (void)mineDetailDataFromNet;


#pragma mark- 修改资料
/**修改资料*/
- (void)changeMineDataFromNetWithType:(NSString *)type
                               andSex:(NSString *)sex
                          andNickName:(NSString *)nickName
                       andAddressName:(NSString *)name
                           andRephone:(NSString *)rephone
                            andRegion:(NSString *)region
                           andAddress:(NSString *)address;

#pragma mark- 我的邀请码-邀请链接
/**我的邀请码-邀请链接*/
- (void)mineInviateCodeAndInviateLink;


#pragma mark- 提交邀请码
/**提交邀请码*/
- (void)iniateCodePushAndinviateCode:(NSString *)code;


#pragma mark- 反馈列表
/**反馈列表*/
- (void)respondListFromNetWithPage:(NSInteger)page;

#pragma mark- 提交反馈
/**提交反馈*/
- (void)respondSendToNetWithContent:(NSString *)content;


#pragma -mark 推送文章的分享链接
/**推送文章的分享链接*/
- (void)pushArticleShareAndSlinkWithID:(NSString *)ID;


#pragma mark- 获取高收益文章的收益
/**获取高收益文章的收益*/
- (void)getHeightPriceArticleMoneyWithArticleID:(NSString * )aid andPrice:(NSString *)read_price;

#pragma mark- 版本更新
/**版本更新*/
- (void)checkNewVersionFromNet;

#pragma mark- 获取自动跳转分享链接
/**自动跳转分享链接*/
- (void)getAutoShareLinkFromNetWithShareType:(NSString *)type andAid:(NSString *)aid andUid:(NSString *)uid;


#pragma mark- 联系我们qq号获取
/**联系我们qq号获取*/
- (void)getQQnumberFromNet;

#pragma mark- 审核隐藏
/**审核隐藏 data = 1 显示 ；data=0 隐藏 */
- (void)hidenWhenReviewFromNet;

@end
