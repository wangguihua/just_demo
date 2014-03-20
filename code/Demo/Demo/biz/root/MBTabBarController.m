//
//  MBTabBarController.m
//  BOCMBCI
//
//  Created by Tracy E on 13-3-25.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBTabBarController.h"


#import "UITabBar+TabBarButtons.h"
#import "MBConstant.h"
#import "MBGlobalUICommon.h"
#import "MBPresentView.h"
#import "MBAlertView.h"
#import "MBUserInfo.h"

#import "MBIIRequest.h"
#import "MBFileManager.h"
#import "UIDevice+DevicePrint.h"
#import "AppDelegate.h"
#import "MBLabel.h"
#import "SMPageControl.h"
#import "HomeViewController.h"

@interface UITabBar (CustomStyle)
@end

@implementation UITabBar (CustomStyle)

- (void)drawRect:(CGRect)rect
{
    if (MBOSVersion() < 5.0) {
        UIImage *image;
        image = [UIImage imageNamed:@"tabBarBG.png"];
        [image drawInRect:CGRectMake(0, self.bounds.size.height - image.size.height,
                                     self.bounds.size.width, image.size.height)];
    }
}
@end

//--------------------------------------------------------------------------------------------------
//TabBar上的快捷菜单Item
@interface MBShortcutButton : UIImageView
@property (nonatomic, strong) MBLabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *url;
+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url;
@end

@implementation MBShortcutButton

+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url{
    return [[MBShortcutButton alloc] initWithTitle:title image:image url:url];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url{
    self = [super init];
    if (self) {
        self.url = url;
        
        self.userInteractionEnabled = YES;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        [self addSubview:_imageView];
        
        _imageView.image = image;
        
        _textLabel = [[MBLabel alloc] initWithFrame:CGRectMake(0, 55, 52, 20)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:13];
        _textLabel.textColor = HEX(@"#ffffff");
        _textLabel.text = title;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.isPaoMaDeng = NO;
        [self addSubview:_textLabel];
    }
    return self;
}
@end


//--------------------------------------------------------------------------------------------------
@interface MBTabBarController (){
    UIButton *              _tabBarActionButton;
    UILabel  *              _tabBarActionLabl;
    BOOL                    _isActionAnimating;
    
    NSArray *               _menuList;
    UIButton *              _menuBackButton;
    MBPresentView *         _menuListView;
    UITableView *           _menuTableView;
    MBShortcutButton *      _currentAddedButton;
    UILabel *               _menuTipLabel;
    
    UIImageView *           _defaultView;
    NSString *              _appStoreURL;
    
    SMPageControl    *_showCurPageControl;

    UIControl *             _shortcutBackgroundView;
    UIImageView *           _menuBG;
    BOOL                    _isMenuShow;
    
}

@end

@implementation MBTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _homeViewControllerOne = [[HomeViewController alloc] init];
    _homeViewControllerTwo = [[HomeViewController alloc] init];
    _homeViewControllerThree = [[HomeViewController alloc] init];
    _homeViewControllerFour = [[HomeViewController alloc] init];
    _homeViewControllerOne.title=@"掌上健康";
    _homeViewControllerTwo.title=@"掌上健康";
    _homeViewControllerThree.title=@"掌上健康";
    _homeViewControllerFour.title=@"掌上健康";

    if (MBOSVersion() >= 6.0)
    {
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }

    UINavigationController *mobileBankNavigationController =
    [[UINavigationController alloc] initWithRootViewController:_homeViewControllerOne];
    
    mobileBankNavigationController.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"饮食"
                                   image:[UIImage imageNamed:@"tabBarItem1.png"]
                                     tag:0];
    mobileBankNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabBarItem1_red.png"];
    
    
    UINavigationController *fidgetNavigationController =
    [[UINavigationController alloc] initWithRootViewController:_homeViewControllerTwo];
    fidgetNavigationController.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"运动"
                                   image:[UIImage imageNamed:@"tabBarItem2.png"]
                                     tag:1];
    
    fidgetNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabBarItem2_red.png"];

    

    UINavigationController *newsNavigationController =
    [[UINavigationController alloc] initWithRootViewController:_homeViewControllerThree];
    newsNavigationController.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"咨询"
                                   image:[UIImage imageNamed:@"tabBarItem3.png"]
                                     tag:3];
    newsNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabBarItem3_red.png"];

    

    
    UINavigationController *informationNavigationController =
    [[UINavigationController alloc] initWithRootViewController:_homeViewControllerFour];
    informationNavigationController.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"更多"
                                   image:[UIImage imageNamed:@"tabBarItem4.png"]
                                     tag:4];
    
    informationNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabBarItem4_red.png"];

    
    UIViewController *cenger=[[UIViewController alloc]init];
    cenger.view.backgroundColor=[UIColor redColor];
    
    self.viewControllers = @[mobileBankNavigationController,
                                    fidgetNavigationController,
                                          cenger,
                                    newsNavigationController,
                             informationNavigationController];
    
    [self addCustomTabBarButton];
    
    
}

#pragma mark - Custom Methods
//配置程序外观（StatusBar | NavigationBar | TabBar）

-(void)addCustomTabBarButton
{
    UIImage *buttonImage = [UIImage imageNamed:@"tabBarMenu.png"];
    _tabBarActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _tabBarActionButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    _tabBarActionButton.frame = CGRectMake(0.0, 0, 30, 30);
    [_tabBarActionButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_tabBarActionButton addTarget:self action:@selector(showPopMenu) forControlEvents:UIControlEventTouchUpInside];
    _tabBarActionButton.center = CGPointMake(self.tabBar.center.x, _tabBarActionButton.center.y);
    _tabBarActionLabl =[[UILabel alloc]initWithFrame:CGRectMake(_tabBarActionButton.frame.origin.x+2, _tabBarActionButton.frame.origin.y+33, 40, 20)];
    _tabBarActionLabl.text=@"个人";
    _tabBarActionLabl.font=[UIFont systemFontOfSize:11];
    _tabBarActionLabl.textColor=kTipTextColor;
    [self.tabBar addSubview:_tabBarActionLabl];
    _tabBarActionLabl.userInteractionEnabled=NO;
    [self.tabBar addSubview:_tabBarActionButton];
}



#pragma mark - UITabBarDelegate Method
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{

    if (_isMenuShow) {
        [_shortcutBackgroundView removeFromSuperview];
        _shortcutBackgroundView = nil;
        
        _tabBarActionButton.transform = CGAffineTransformMakeRotation(0);
        _isMenuShow = NO;
        [_tabBarActionButton setBackgroundImage:[UIImage imageNamed:@"tabBarMenu.png"] forState:UIControlStateNormal];
        _tabBarActionLabl.textColor=kTipTextColor;
        _isActionAnimating = NO;
        
    }
    


}




- (void)showPopMenu{

    if (_isActionAnimating) {
       
        return;
    }
    _isActionAnimating = YES;
    [_tabBarActionButton setBackgroundImage:[UIImage imageNamed:@"tabBarMenu_hight.png"] forState:UIControlStateNormal];
    _tabBarActionLabl.textColor=[UIColor blueColor];

    if (!_shortcutBackgroundView) {
        _shortcutBackgroundView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UIImageView *bageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight-264, 320, 264)];
        bageView.image =[UIImage imageNamed:@"menuBg.png"];
        [_shortcutBackgroundView addSubview:bageView];
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(146, kScreenHeight-264+5, 37, 16);
        [btn addTarget:self action:@selector(uploadView) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"menbgBtn.png"] forState:UIControlStateNormal];
        [_shortcutBackgroundView addSubview:btn];

    }
    
    NSArray *itemArray = @[@"资料",@"收藏",@"预约记录",@"问卷",@"膳食推荐"];
    NSArray *itemAImagerray = @[@"information_normal.png",@"star_pressed.png",@"disease_gif_normal.png",@"disease_icon.png",@"risk_normal.png"];

    if (!_isMenuShow) {
        for (int i = 0; i < 5; i++) {
            NSInteger tag = 100 + i;
            
            MBShortcutButton *item = [MBShortcutButton itemWithTitle:itemArray[i] image:[UIImage imageNamed:itemAImagerray[i]] url:itemAImagerray[i]];
          
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCurmenu:)];
            [item addGestureRecognizer:tapGesture];
            if (i<4) {
                item.frame = CGRectMake(20*(i+1)+55*i, kScreenHeight-160-70, 55, 80);

            }else
            {
                item.frame = CGRectMake(20, kScreenHeight-160+5+10, 55, 80);

            }
            item.tag = tag;
            [_shortcutBackgroundView addSubview:item];
        }

        [_shortcutBackgroundView addTarget:self action:@selector(showPopMenu) forControlEvents:UIControlEventTouchUpInside];
        _shortcutBackgroundView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:_shortcutBackgroundView belowSubview:self.tabBar];
        
        
        
    } else {
        [_shortcutBackgroundView removeFromSuperview];
        _isActionAnimating = NO;
    }
    _isMenuShow = !_isMenuShow;
}

-(void)showCurmenu:(UIGestureRecognizer*)gesture
{
    if (_isMenuShow) {
        [_shortcutBackgroundView removeFromSuperview];
        _shortcutBackgroundView = nil;
        
        _tabBarActionButton.transform = CGAffineTransformMakeRotation(0);
        _isMenuShow = NO;
        [_tabBarActionButton setBackgroundImage:[UIImage imageNamed:@"tabBarMenu.png"] forState:UIControlStateNormal];
        _tabBarActionLabl.textColor=kTipTextColor;
        _isActionAnimating = NO;
        
    }

    MBShortcutButton*_currentAddedButton = (MBShortcutButton *)[gesture view];

    
}
-(void)uploadView
{
    if (_isMenuShow) {
        
        [_shortcutBackgroundView removeFromSuperview];
        _shortcutBackgroundView = nil;
        
        _tabBarActionButton.transform = CGAffineTransformMakeRotation(0);
        _isMenuShow = NO;
        [_tabBarActionButton setBackgroundImage:[UIImage imageNamed:@"tabBarMenu.png"] forState:UIControlStateNormal];
        _tabBarActionLabl.textColor=kTipTextColor;
        _isActionAnimating = NO;
        
    }

}
@end
