//
//  SLNCard.h
//  DynamicPlayground
//
//  Created by iSlan on 4/17/14.
//  Copyright (c) 2014 SLN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLNCard;

@protocol SLNCardDelegate <NSObject>

- (void)dynamicCard:(SLNCard *)card didBeginMoveWithPoint:(CGPoint)point;
- (void)dynamicCard:(SLNCard *)card didMoveWithPoint:(CGPoint)point;
- (void)dynamicCard:(SLNCard *)card didCancelMoveWithPoint:(CGPoint)point;
- (void)dynamicCard:(SLNCard *)card didEndMoveWithVelocityPoint:(CGPoint)point;
//- (void)dynamicCard:(SLNCard *)card finishMoveOutScreen;

@end

@interface SLNCard : UIView

@property (assign, nonatomic) NSInteger originalIndex;
@property (assign, nonatomic) id <SLNCardDelegate> delegate;

- (id)initWithColor:(UIColor *)color content:(NSString *)content;

@end
