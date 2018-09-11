//
//  UIView+DWAngle.h
//  DWAppleAlarm
//
//  Created by lg on 2018/9/7.
//  Copyright © 2018年 lg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DWAngle)

/** 两个坐标点的角度 */
+ (CGFloat)angleBetweenPoint1:(CGPoint)first point2:(CGPoint)second AndCenter:(CGPoint)center;

/** 两点的距离 */
+(CGFloat)distanceBetweenPointA:(CGPoint)pointA AndPiontB:(CGPoint)pointB;
/** 某点和原点间的角度 */
+(CGFloat)angleBetweenOriginAndPointA:(CGPoint)p;

@end
