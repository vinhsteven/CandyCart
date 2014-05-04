//
//  MyOrderViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/18/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "MyOrderViewController.h"

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

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
    [self.view setNuiClass:@"ViewInit"];
    self.title = NSLocalizedString(@"orderViewController_title", nil) ;
	// Do any additional setup after loading the view.
    
    scroller = [MGScrollView scroller];
    
    scroller.frame = [[DeviceClass instance] getResizeScreen:NO];
        
    scroller.bottomPadding = 8;
    
    scroller.delegate = self;
    scroller.alwaysBounceVertical = YES;
    
    [self.view addSubview:scroller];
    
    [self setOrderView];
    
    filter = [UIButton buttonWithType:UIButtonTypeCustom];
    filter.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    filter.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [filter setTitle:NSLocalizedString(@"orderViewController_filter_btn_title", nil) forState:UIControlStateNormal];
    [filter addTarget:self
                 action:@selector(filterAction)
       forControlEvents:UIControlEventTouchDown];
    
    [filter setNuiClass:@"UiBarButtonItem"];
    [filter.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:filter];
    self.navigationItem.rightBarButtonItem = button;
    
}


-(void)filterAction{
    GeneralPopTableView *genral = [[GeneralPopTableView alloc] init];
    genral.delegate = self;
    
    [genral initGeneralPopTableView:@"status_label" detailList:nil menuItem:[[[SettingDataClass instance] getSetting] objectForKey:@"status_list"]];
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:genral];
    popover.border = YES;
    popover.contentSize = CGSizeMake(170,170);
    [popover.view setNuiClass:@"DropDownView"];
    [popover presentPopoverFromView:filter];
}

-(void)didChooseGeneralPopTableView:(NSDictionary *)chooseData
{
    NSLog(@"Choose Data : %@",chooseData);
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(didChooseGeneralPopTableViewExe:) onTarget:self withObject:chooseData animated:YES];
}

-(void)didChooseGeneralPopTableViewExe:(NSDictionary*)data{
//    NSDictionary *getListOfMyOrder = [[DataService instance] get_my_order:[UserAuth instance].username password:[UserAuth instance].password filter:[data objectForKey:@"status_label"]];
    NSDictionary *getListOfMyOrder = [[DataService instance] get_my_order:[UserAuth instance].username password:[UserAuth instance].password filter:[data objectForKey:@"status_slug"]];
    [[MyOrderClass instance] setListOfMyOrder:getListOfMyOrder];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setOrderView];
    });
}

-(void)setOrderView{
    [scroller.boxes removeAllObjects];
    NSDictionary *getMyListOfOrder = [[MyOrderClass instance] getListOfMyOrder];
    
    NSArray *lists = [getMyListOfOrder objectForKey:@"my_order"];
    if([lists count] == 0)
    {
        [self noOrderBox];
    }
    else
    {
        for(int i=0;i<[lists count];i++)
        {
            NSDictionary *list = [lists objectAtIndex:i];
            [self order_box:[list objectForKey:@"orderID"] status:[list objectForKey:@"status"] orderDate:[list objectForKey:@"orderDate"] price:[NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[list objectForKey:@"order_total"]]] orderInfo:list];
        }
    }
    
    [scroller layoutWithSpeed:0.3 completion:nil];
}


-(void)order_box:(NSString*)orderNo status:(NSString*)status orderDate:(NSString*)orderDate price:(NSString*)totalPrice orderInfo:(NSDictionary*)orderInfo{
    
    if ([status isEqualToString:@"All"])
        status = NSLocalizedString(@"status_list.all", nil);
    else if ([status isEqualToString:@"pending"])
        status = NSLocalizedString(@"status_list.pending", nil);
    else if ([status isEqualToString:@"failed"])
        status = NSLocalizedString(@"status_list.failed", nil);
    else if ([status isEqualToString:@"on-hold"])
        status = NSLocalizedString(@"status_list.on-hold", nil);
    else if ([status isEqualToString:@"processing"])
        status = NSLocalizedString(@"status_list.processing", nil);
    else if ([status isEqualToString:@"completed"])
        status = NSLocalizedString(@"status_list.completed", nil);
    else if ([status isEqualToString:@"refunded"])
        status = NSLocalizedString(@"status_list.refunded", nil);
    else if ([status isEqualToString:@"cancelled"])
        status = NSLocalizedString(@"status_list.cancelled", nil);
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    img.frame = CGRectMake(300-27, 30, 18, 18);
    
    MGLineStyled *header = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"#%@ - %@",orderNo,status] right:img size:CGSizeMake(300, 40)];
    header.font = [UIFont fontWithName:BOLDFONT size:14];
    header.leftPadding = header.rightPadding = 16;
    [section.topLines addObject:header];
    
    MGLineStyled *body1 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",orderDate] right:totalPrice size:CGSizeMake(300, 40)];
    body1.font = [UIFont fontWithName:PRIMARYFONT size:12];
    body1.leftPadding = header.rightPadding = 16;
    [section.topLines addObject:body1];
    
    
    section.onTap = ^{
        [[MyOrderClass instance] setMyOrder:orderInfo];
    
        //[[MainViewClass instance] openOrderViewController];
        OrderViewController *order = [[OrderViewController alloc] init];
        [order noCloseBtn];
        [self.navigationController pushViewController:order animated:YES];
        
    };
}

-(void)noOrderBox
{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    
    id body = NSLocalizedString(@"orderViewController_no_order_title", nil);
    
    
    
    // stuff
    MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:300
                                                 padding:UIEdgeInsetsMake(10, 10, 10, 10)];
    line.backgroundColor = [UIColor clearColor];
    line.borderStyle &= ~MGBorderEtchedBottom;
    [section.topLines addObject:line];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollViews
{
    initialContentOffset = scrollViews.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollViews
{
    
    [[SettingDataClass instance] autoHideGlobal:scrollViews navigationView:self.navigationController contentOffset:initialContentOffset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
