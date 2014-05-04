//
//  ImageGalleryThumbController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/27/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ImageGalleryThumbController.h"

@interface ImageGalleryThumbController ()

@end

@implementation ImageGalleryThumbController

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
	// Do any additional setup after loading the view.
    [self.view setNuiClass:@"ViewInit"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    scroller = [MGScrollView scroller];
    scroller.frame = [[DeviceClass instance] getResizeScreen:NO];
    scroller.delegate = self;
    scroller.contentLayoutMode = MGLayoutGridStyle;
    scroller.bottomPadding = 8;
    scroller.alwaysBounceVertical = YES;
    [self.view addSubview:scroller];
    [self createView];
    
    
    
}

-(void)createView{
    photos = [[NSMutableArray alloc] init];
    
    for(int i = 0;i<[info count];i++)
    {
        NSString *url = [info objectAtIndex:i];
        [self image_box:url index:i];
        
        [photos addObject:[IDMPhoto photoWithURL:[NSURL URLWithString:url]]];
    }
    [scroller layoutWithSpeed:0.3 completion:nil];
}




-(void)image_box:(NSString*)url index:(int)index{
    MGBox *section =  MGBox.box;
    section.margin = UIEdgeInsetsMake(5.0, 5.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    ImageGalleryBox *thumb = [ImageGalleryBox imgThumb:CGSizeMake(100,100) img:url];
    [section.boxes addObject:thumb];
    
    
    
    section.onTap = ^{
        
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:thumb];
        
        browser.delegate = self;
        [browser setInitialPageIndex:index];
       browser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        // Show
        [self presentViewController:browser animated:NO completion:nil];
        
    };

    
    

    
}

-(void)setImageInfo:(NSArray*)setInfo{
    
    info = setInfo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
