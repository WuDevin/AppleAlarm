//
//  DWRotaionGestureRecognizer.m
//  DWAppleAlarm
//
//  Created by lg on 2018/9/7.
//  Copyright © 2018年 lg. All rights reserved.
//

#import "DWRotaionGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UIView+DWAngle.h"

@interface DWRotaionGestureRecognizer()

@property (nonatomic) CGFloat  currentRotation;
@property(nonatomic) CGPoint endPoint;
@property(nonatomic) CGPoint center;
@property(nonatomic) CGFloat previousRotation;
@property(nonatomic) CGPoint startingPoint;

@end

@implementation DWRotaionGestureRecognizer

#pragma mark - Init                         - Method -
- (id) initWithCenter:(CGPoint)center
{
    self = [super init];
    if (self) {
        self.center = center;
        self.currentRotation = 0;
        self.previousRotation = 0;
        self.startingPoint = CGPointZero;
        self.endPoint = CGPointZero;
    }
    return self;
}

#pragma mark - PubilcMethod                      - Method -
- (CGFloat)rotation {
    return self.currentRotation + self.previousRotation;
}

-(CGPoint)beginPoint{
    return self.startingPoint;
}

- (void)resetRotation {
    self.currentRotation = 0;
    self.previousRotation = 0;
}

/**拖动结束后自动重置 */
- (void)reset
{
    [super reset];
//    _previousRotation = [self rotation];
    _previousRotation = 0;
    _currentRotation = 0;
}

#pragma mark - eventResponse                - Method -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.startingPoint = [[touches anyObject] locationInView:self.view];
    self.state = UIGestureRecognizerStateBegan;
    
    if (self.rotaionGestureRecognizerDelegate && [self.rotaionGestureRecognizerDelegate respondsToSelector:@selector(touchesBegan:withEvent:)]) {
        [self.rotaionGestureRecognizerDelegate touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    CGPoint point = [[touches anyObject] locationInView:self.view];
     self.currentRotation = [UIView angleBetweenPoint1:self.startingPoint point2:point AndCenter:self.center];
    self.state = UIGestureRecognizerStateChanged;
    
    if (self.rotaionGestureRecognizerDelegate && [self.rotaionGestureRecognizerDelegate respondsToSelector:@selector(touchesMoved:withEvent:)]) {
        [self.rotaionGestureRecognizerDelegate touchesMoved:touches withEvent:event];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.endPoint = [[touches anyObject] locationInView:self.view];
    self.currentRotation = [UIView angleBetweenPoint1:self.startingPoint point2:self.endPoint AndCenter:self.center];
    self.state = UIGestureRecognizerStateEnded;
    
    if (self.rotaionGestureRecognizerDelegate && [self.rotaionGestureRecognizerDelegate respondsToSelector:@selector(touchesEnded:withEvent:)]) {
        [self.rotaionGestureRecognizerDelegate touchesEnded:touches withEvent:event];
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
    
    if (self.rotaionGestureRecognizerDelegate && [self.rotaionGestureRecognizerDelegate respondsToSelector:@selector(touchesCancelled:withEvent:)]) {
        [self.rotaionGestureRecognizerDelegate touchesCancelled:touches withEvent:event];
    }
}


@end
