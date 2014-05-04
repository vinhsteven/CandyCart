//
//  Created by matt on 10/11/12.
//

#import "MGLineStyled.h"

#define DEFAULT_SIZE (CGSize){304, 40}

@implementation MGLineStyled

- (void)setup {
  [super setup];

  // default styling
  self.backgroundColor = [UIColor whiteColor];
  self.padding = UIEdgeInsetsMake(0, 16, 0, 16);

  // use MGBox borders instead of the maybe-to-be-deprecated solidUnderline
  self.borderStyle = MGBorderEtchedTop | MGBorderEtchedBottom;
}

+ (id)line {
  return [self boxWithSize:DEFAULT_SIZE];
}

@end
