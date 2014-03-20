//
//  HomeViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-20.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "HomeViewController.h"
#import "MBConstant.h"
@interface HomeViewController ()
{
    UIImageView *_headImageView;
    UILabel *_userName;
}
@end

@implementation HomeViewController

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
    [self makeViewAboutDownLoadView];
   self.view.backgroundColor= HEX(@"#5ec4fe");
    UIBarButtonItem *rightBarItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"phone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemBtnPressed:)];
    self.navigationItem.rightBarButtonItem=rightBarItem;
    
    _headImageView =[[UIImageView alloc]initWithFrame:CGRectMake(110, 100, 100, 101)];
    _headImageView.image =[UIImage imageNamed:@"man.png"];
    [self.view addSubview:_headImageView];
    _userName =[[UILabel alloc]initWithFrame:CGRectMake(0, _headImageView.frame.origin.y+95, 320, 40)];
    _userName.textAlignment=NSTextAlignmentCenter;
    _userName.font =[UIFont boldSystemFontOfSize:20];
    _userName.textColor=HEX(@"#ffffff");
    _userName.text=@"汪桂华";
    [self.view addSubview:_userName];
}
-(void)rightBarItemBtnPressed:(UIBarButtonItem*)rightBtn
{
    
}
-(void)makeViewAboutDownLoadView
{
    UIView *viewBG =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-49-8-85-8-8-85-3, 320, -(-49-8-85-8-8-85))];
    viewBG.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:viewBG];
    UIButton *btnOne =[UIButton buttonWithType:UIButtonTypeCustom];
    btnOne.frame = CGRectMake(8, 8, 148, 85);
    [btnOne setBackgroundImage:[UIImage imageNamed:@"tjbg.png"] forState:UIControlStateNormal];
    [viewBG addSubview:btnOne];
    
    UIButton *btnTwo =[UIButton buttonWithType:UIButtonTypeCustom];
    btnTwo.frame = CGRectMake(8+8+148, 8, 148, 85);
    [btnTwo setBackgroundImage:[UIImage imageNamed:@"jkzc.png"] forState:UIControlStateNormal];
    [viewBG addSubview:btnTwo];
    
    UIButton *btnThree =[UIButton buttonWithType:UIButtonTypeCustom];
    btnThree.frame = CGRectMake(8, 8+8+85, 148, 85);
    [btnThree setBackgroundImage:[UIImage imageNamed:@"tjyy.png"] forState:UIControlStateNormal];
    [viewBG addSubview:btnThree];
    
    UIButton *btnFour =[UIButton buttonWithType:UIButtonTypeCustom];
    btnFour.frame = CGRectMake(8+8+148, 8+8+85, 148, 85);
    [btnFour setBackgroundImage:[UIImage imageNamed:@"gdzx.png"] forState:UIControlStateNormal];
    [viewBG addSubview:btnFour];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
