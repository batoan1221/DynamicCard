//
//  SLNCard.m
//  DynamicPlayground
//
//  Created by iSlan on 4/17/14.
//  Copyright (c) 2014 SLN. All rights reserved.
//

#import "SLNCard.h"

@implementation SLNCard

- (id)initWithColor:(UIColor *)color content:(NSString *)content
{
    self = [self initWithFrame:CGRectMake(0, 0, 275, 200)];
    self.backgroundColor = color;
    self.layer.cornerRadius = 15;
    self.alpha = 0.9;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 250, 40)];
    contentLabel.text = content;
    [contentLabel setFont:[UIFont systemFontOfSize:20]];
    [self addSubview:contentLabel];
    return self;
}

@end
