//
//  OrderNotesViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/18/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "OrderNotesViewController.h"

@interface OrderNotesViewController ()

@end

@implementation OrderNotesViewController

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
    self.title = NSLocalizedString(@"orderNotes_viewController_title", nil);
	// Do any additional setup after loading the view.
    
    scroller = [MGScrollView scroller];
        
    scroller.frame = [[DeviceClass instance] getResizeScreen:NO];
        
    scroller.bottomPadding = 8;
    
    scroller.delegate = self;
    scroller.alwaysBounceVertical = YES;
    
    [self.view addSubview:scroller];
    
    [self setNotesView];
}

-(void)setNotesView{
    NSArray *getNotes = [[[MyOrderClass instance] getMyOrder] objectForKey:@"order_notes"];
    
    if([getNotes count] == 0)
    {
        [self noOrderNotesBox];
    }
    else
    {
    for(int i=0;i<[getNotes count];i++)
    {
        NSDictionary *data = [getNotes objectAtIndex:i];
        [self notes_box:[data objectForKey:@"content"] date:[data objectForKey:@"ago"]];
        
    }
    }
    [scroller layoutWithSpeed:0.3 completion:nil];
}


-(void)noOrderNotesBox
{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    
    
    
    id body = NSLocalizedString(@"orderNotes_viewController_no_notes", nil);
    
    
    
    // stuff
    MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:300
                                                 padding:UIEdgeInsetsMake(10, 10, 10, 10)];
    line.backgroundColor = [UIColor clearColor];
    line.borderStyle &= ~MGBorderEtchedBottom;
    [section.topLines addObject:line];
    
    
    
    
}


-(void)notes_box:(NSString*)commentContent date:(NSString*)date{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    img.frame = CGRectMake(300-27, 30, 18, 18);
    
    
    
    
    
    MGLineStyled *commentContents = MGLineStyled.line;
    commentContents.multilineLeft = [[ToolClass instance] decodeHTMLCharacterEntities:commentContent];
    commentContents.minHeight = 40;
    [section.topLines addObject:commentContents];
    
    
    MGLineStyled *body1 = [MGLineStyled lineWithLeft:nil right:[NSString stringWithFormat:@"%@",date] size:CGSizeMake(300, 40)];
    body1.font = [UIFont fontWithName:PRIMARYFONT size:12];
    body1.leftPadding = commentContents.rightPadding = 16;
    [section.topLines addObject:body1];
    
    
   
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
