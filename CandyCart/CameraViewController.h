//
//  CameraViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/5/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
@interface CameraViewController : UIViewController<ZBarReaderViewDelegate,MBProgressHUDDelegate>
{
    ZBarReaderView *readerView;
     ZBarCameraSimulator *cameraSim;
     MBProgressHUD *HUD;
}
@property (nonatomic, retain) IBOutlet ZBarReaderView *readerView;
@end
