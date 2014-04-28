//
//  SLNCard.h
//  DynamicPlayground
//
//  Created by iSlan on 4/17/14.
//  Copyright (c) 2014 SLN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLNCard : UIView

@property (assign, nonatomic) NSInteger originalIndex;
- (id)initWithColor:(UIColor *)color content:(NSString *)content;

@end
