//
//  SLNViewController.m
//  DynamicPlayground
//
//  Created by iSlan on 4/16/14.
//  Copyright (c) 2014 SLN. All rights reserved.
//

#import "SLNViewController.h"
#import "SLNCard.h"

@interface SLNViewController ()
<UICollisionBehaviorDelegate>

@property (strong, nonatomic) NSArray * colors;
@property (strong, nonatomic) NSMutableArray * cards;

@end

@implementation SLNViewController
{
    UISnapBehavior *_snap;
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collision;
    UIAttachmentBehavior *_attachment;
    UIDynamicItemBehavior *_itemBehavior;
}

- (NSArray *)colors{
    if (!_colors) {
        _colors = @[[UIColor blueColor],
                    [UIColor cyanColor],
                    [UIColor darkGrayColor],
                    [UIColor greenColor],
                    [UIColor orangeColor],
                    [UIColor purpleColor],
                    [UIColor redColor],
                    [UIColor yellowColor]];
    }
    return _colors;
}

- (NSMutableArray *)cards{
    if (!_cards) {
        _cards = [@[] mutableCopy];
    }
    return _cards;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int i = 0; i < 8; i++) {
        CGFloat angle = M_PI/12*(i - 6);
        SLNCard * card = [[SLNCard alloc] initWithColor:self.colors[i]
                                                content:[NSString stringWithFormat:@"Content goes here! No.%d",8 - i]];
        CGFloat px = cos(4 * angle)*1200 + self.view.center.x;
        CGFloat py = sin(4 * angle)*1200 + self.view.center.y;
        card.center = CGPointMake(px, py);
        
        card.alpha = 0;
        
        CGAffineTransform firstTransform = CGAffineTransformMakeScale(0.1, 0.1);
        firstTransform = CGAffineTransformMakeRotation(angle + M_PI);
        card.transform = firstTransform;
        
        CGAffineTransform finalTransform = CGAffineTransformMakeScale(1, 1);
        finalTransform = CGAffineTransformMakeRotation(angle);
        
        [UIView animateWithDuration:1
                              delay:i*0.1
             usingSpringWithDamping:0.8
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             card.center = self.view.center;
                             card.transform = finalTransform;
                             card.alpha = 0.8;
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  card.alpha = 0.9;
                                              }];
                         }];
        
        [self.view addSubview:card];
        [self.cards addObject:card];
        [self addGestureToCard:card];
    }
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[]];
    _gravity.magnitude = 5;
    [_animator addBehavior:_gravity];
    
    _collision = [[UICollisionBehavior alloc] initWithItems:@[]];
    [_collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-1000, -1000, -1000, -1000)];
    _collision.collisionDelegate = self;
    [_animator addBehavior:_collision];
    
    _itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
    [_animator addBehavior:_itemBehavior];
}

- (void)addGestureToCard:(SLNCard *)card{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleGesture:)];
    [card addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [card addGestureRecognizer:tapGesture];
}

- (void)handleGesture:(UIGestureRecognizer *)gesture{
    UIView* draggedView = gesture.view;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            [self handleGestureBeganWithGesture:gesture inView:draggedView];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
                _attachment.anchorPoint = [gesture locationInView:self.view];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
                [self handleGestureBeganWithGesture:gesture inView:draggedView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [_animator removeBehavior:_attachment];
                });
            }
            if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]){
                [self addVelocityToView:draggedView fromGesture:(UIPanGestureRecognizer *)gesture];
                [_animator removeBehavior:_attachment];
            }
            [_collision addItem:draggedView];
            break;
        default:
            break;
    }

}

- (void)handleGestureBeganWithGesture:(UIGestureRecognizer *)gesture inView:(UIView *)view{
    [_itemBehavior addItem:view];
    [_gravity addItem:view];
    UIOffset offset = UIOffsetMake([gesture locationInView:view].x - view.bounds.size.width / 2, [gesture locationInView:view].y - view.bounds.size.height / 2);
    
    _attachment = [[UIAttachmentBehavior alloc]
                   initWithItem:view
                   offsetFromCenter:offset
                   attachedToAnchor:[gesture locationInView:self.view]];
    _attachment.damping = 0;
    _attachment.length = 0;
    [_animator addBehavior:_attachment];
}

- (void)addVelocityToView:(UIView*)view fromGesture:(UIPanGestureRecognizer*)gesture {
    CGPoint vel = [gesture velocityInView:self.view];
    UIDynamicItemBehavior* behaviour = [self itemBehaviourForView:view];
    [behaviour addLinearVelocity:vel forItem:view];
}

- (UIDynamicItemBehavior*) itemBehaviourForView:(UIView*)view {
    for (UIDynamicItemBehavior* behaviour in _animator.behaviors) {
        if (behaviour.class == [UIDynamicItemBehavior class]
            && [behaviour.items firstObject] == view) {
            return behaviour;
        }
    }
    return nil;
}

- (void)goBackWithCardView:(SLNCard *)card{
    [self.view sendSubviewToBack:card];
    
    _snap = [[UISnapBehavior alloc] initWithItem:card snapToPoint:self.view.center];
    _snap.damping = 2;
    [_animator addBehavior:_snap];
    
    __weak UIDynamicAnimator *_weakAnimator = _animator;
    __weak SLNCard *_weakCard = card;
    __weak UIViewController *_weakSelf = self;
    __weak UISnapBehavior *_weakSnap = _snap;
    __weak NSArray *_weakCards = self.cards;

    _snap.action = ^{
        NSInteger index = [_weakCards indexOfObject:_weakCard];
        _weakCard.transform = CGAffineTransformMakeRotation(M_PI/12*(index - 6));
        if (_weakCard.center.x == _weakSelf.view.center.x && _weakCard.center.y == _weakSelf.view.center.y) {
            [_weakAnimator removeBehavior:_weakSnap];
        }
    };
}

- (void)rotateAllCardWithIndex:(NSInteger)index{
    for (NSInteger i = index - 1; i >= 0; i--) {
        [UIView animateWithDuration:0.2
                              delay:(index - 1 - i)*0.1
                            options:0
                         animations:^{
                             ((SLNCard *)self.cards[i]).transform = CGAffineTransformMakeRotation(M_PI/12*(i - 5));
                         }
                         completion:nil];
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    SLNCard *card = (SLNCard *)item;
    NSInteger index = [self.cards indexOfObject:card];
    
    [_gravity removeItem:card];
    [behavior removeItem:card];
    [_itemBehavior removeItem:card];
    
    [self goBackWithCardView:card];
    [self rotateAllCardWithIndex:index];
    
    [self.cards removeObject:card];
    [self.cards insertObject:card atIndex:0];
}

@end
