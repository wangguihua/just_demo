//
//  MBMessageBoard.m
//  BOCMBCI
//
//  Created by Tracy E on 13-3-26.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBMessageBoard.h"
#import <QuartzCore/QuartzCore.h>
#import "MBConstant.h"
#import "MBUserInfo.h"

#define kBoardViewTag 10

@implementation MBMessageBoard{
    NSMutableArray *_buttons;
    NSArray *_news;
    NSArray *_tips;
    
    UIView *_historyView;
    UILabel *_loginTimeLabel;
    UILabel *_lastLoginTimeLabel;
    
    UIView *_userInfoView;
    UILabel *_loginHintLabel;
    
    UITableView *_tableView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    [_buttons removeAllObjects];
    
    
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"messageBoard.png"]];
        _buttons = [[NSMutableArray alloc] init];
        NSArray *buttonTitles = @[@"预留信息", @"登录历史", @"特别提醒", @"最新消息"];
        [buttonTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:obj forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            button.tag = idx;
            [button addTarget:self action:@selector(buttonDidSelectedAtItem:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(5 + 78 * idx, 209, 70, 20);
            button.layer.cornerRadius = 5;
            
            if (idx == 3) {
                button.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6];
            }
            [self addSubview:button];
            [_buttons addObject:button];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidLogin:)
                                                     name:MBUserDidLoginNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidLogout:)
                                                     name:MBUserDidLogoutNotification
                                                   object:nil];

        NSDictionary *userInfo = [[MBUserInfo shareUserInfo] userInfo];
        
        //预留信息
        _userInfoView = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 313, 204)];
        _userInfoView.tag = kBoardViewTag;
        _userInfoView.backgroundColor = MB_RGB(244, 244, 244);
        
        UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        tipImageView.backgroundColor = [UIColor redColor];
        [_userInfoView addSubview:tipImageView];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 280, 40)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = kNormalTextFont;
        tipLabel.textColor = kTipTextColor;
        tipLabel.numberOfLines = 2;
        tipLabel.text = @"每次登录时，显示您的预留信息，如果信息不正确，请立即退出，并及时与我行客户服务中心联系。";
        [_userInfoView addSubview:tipLabel];
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        logo.center = _userInfoView.center;
        logo.image = [UIImage imageNamed:@"icon.png"];
        [_userInfoView addSubview:logo];
        
        _loginHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 290, 40)];
        _loginHintLabel.backgroundColor = [UIColor clearColor];
        _loginHintLabel.font = kNormalTextFont;
        _loginHintLabel.textColor = kRedTextColor;
        _loginHintLabel.textAlignment = NSTextAlignmentCenter;
        _loginHintLabel.numberOfLines = 2;
        _loginHintLabel.text = MBNonEmptyString(userInfo[@"loginHint"]);
        [_userInfoView addSubview:_loginHintLabel];
        
        //历史登录
        _historyView = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 313, 204)];
        _historyView.tag = kBoardViewTag;
        _historyView.backgroundColor = MB_RGB(244, 244, 244);
        
        UIImageView *loginTimeView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 25, 89, 57)];
        loginTimeView.image = [UIImage imageNamed:@"login_time.png"];
        [_historyView addSubview:loginTimeView];
                
        _loginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 25, 180, 57)];
        _loginTimeLabel.numberOfLines = 2;
        _loginTimeLabel.backgroundColor = [UIColor clearColor];
        _loginTimeLabel.textAlignment = NSTextAlignmentCenter;
        _loginTimeLabel.font = kNormalTextFont;
        _loginTimeLabel.textColor = kRedTextColor;
        _loginTimeLabel.text = MBNonEmptyString([NSString stringWithFormat:@"您最近一次成功登录本站是\n%@",MBNonEmptyString(userInfo[@"loginDate"])]);
        [_historyView addSubview:_loginTimeLabel];

        
        UIImageView *lastLoginView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 115, 89, 57)];
        lastLoginView.image = [UIImage imageNamed:@"last_login_time.png"];
        [_historyView addSubview:lastLoginView];
        
        _lastLoginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 115, 180, 57)];
        _lastLoginTimeLabel.numberOfLines = 2;
        _lastLoginTimeLabel.backgroundColor = [UIColor clearColor];
        _lastLoginTimeLabel.textAlignment = NSTextAlignmentCenter;
        _lastLoginTimeLabel.font = kNormalTextFont;
        _lastLoginTimeLabel.textColor = kNormalTextColor;
        _lastLoginTimeLabel.text = [NSString stringWithFormat:@"您最近一次失败登录本站是\n%@",MBNonEmptyString(userInfo[@"lastLogin"])];
        [_historyView addSubview:_lastLoginTimeLabel];
        
        //特别提醒
        
        //最新消息
        _news = @[@"1. 携程联手推出旅游出行30%优惠",
                 @"2. 携程联手推出酒店住宿20%优惠",
                 @"3. 中国银行手机银行重装出场，全新界面，炫酷体验",
                 @"4. 中国银行最新推出中银之旅信用卡，机票打8折",
                 @"5. 最近手机银行盗号频发，请注意安全防范常见的"];

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(3, 3, 313, 204)];
        _tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.92 blue:0.92 alpha:1];
        _tableView.rowHeight = 41;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = kBoardViewTag;    //切换视图标记
        [self addSubview:_tableView];
        
    }
    return self;
}

- (void)userDidLogin:(NSNotification *)notification{
    NSLog(@"%s   %d   %@",__FUNCTION__, __LINE__, [notification object]);

    NSDictionary *userInfo = [notification object];
    _loginHintLabel.text = MBNonEmptyString(userInfo[@"loginHint"]);
    _loginTimeLabel.text = [NSString stringWithFormat:@"您最近一次成功登录本站是\n%@",MBNonEmptyString(userInfo[@"loginDate"])];
    _lastLoginTimeLabel.text = [NSString stringWithFormat:@"您最近一次失败登录本站是\n%@",MBNonEmptyString(userInfo[@"lastLogin"])];
}

- (void)userDidLogout:(NSNotification *)notification{
    _loginHintLabel.text = @"";
    _loginTimeLabel.text = @"";
    _lastLoginTimeLabel.text = @"";
}

- (void)buttonDidSelectedAtItem:(UIButton *)button{
    for (UIButton *button in _buttons){
        button.backgroundColor = [UIColor clearColor];
    }
    button.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6];
    
    [[self viewWithTag:10] removeFromSuperview];
    switch (button.tag) {
        case 0:{
            [self addSubview:_userInfoView];
            break;
        }
        case 1:{
            [self addSubview:_historyView];
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            [self addSubview:_tableView];
            break;
        }
        default:
            break;
    }
}

- (void)layoutSubviews{
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_news count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = _news[indexPath.row];
    return cell;
}


@end
