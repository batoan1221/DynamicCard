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
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePanGesture:)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    [self addGestureRecognizer:panGesture];
    
    return self;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture{
//    UIView* draggedView = tapGesture.view;
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan:{
//            break;
//        }
//        case UIGestureRecognizerStateChanged:{
//            if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
//                _attachment.anchorPoint = [gesture locationInView:self.view];
//            }
//            break;
//        }
//        case UIGestureRecognizerStateCancelled:
//        case UIGestureRecognizerStateEnded:
//            if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
//                [self handleGestureBeganWithGesture:gesture inView:draggedView];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                    [_animator removeBehavior:_attachment];
//                });
//            }
//            if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]){
//                [self addVelocityToView:draggedView fromGesture:(UIPanGestureRecognizer *)gesture];
//                [_animator removeBehavior:_attachment];
//            }
//            [_collision addItem:draggedView];
//            break;
//        default:
//            break;
//    }
//    
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            if([self.delegate respondsToSelector:@selector(dynamicCard:didBeginMoveWithPoint:)])
            {
                [self.delegate dynamicCard:self didBeginMoveWithPoint:[panGesture locationInView:self]];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if([self.delegate respondsToSelector:@selector(dynamicCard:didMoveWithPoint:)])
            {
                [self.delegate dynamicCard:self didMoveWithPoint:[panGesture locationInView:self]];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
            if([self.delegate respondsToSelector:@selector(dynamicCard:didCancelMoveWithPoint:)])
            {
                [self.delegate dynamicCard:self didCancelMoveWithPoint:[panGesture locationInView:self]];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if([self.delegate respondsToSelector:@selector(dynamicCard:didEndMoveWithVelocityPoint:)])
            {
                [self.delegate dynamicCard:self didEndMoveWithVelocityPoint:[panGesture velocityInView:self]];
            }
            break;
        default:
            break;
    }
    
}

@end
