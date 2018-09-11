//
//  UIView+DWAngle.m
//  DWAppleAlarm
//
//  Created by lg on 2018/9/7.
//  Copyright © 2018年 lg. All rights reserved.
//

#import "UIView+DWAngle.h"

@implementation UIView (DWAngle)

/** 两个坐标点的角度 */
+ (CGFloat)angleBetweenPoint1:(CGPoint)first point2:(CGPoint)second AndCenter:(CGPoint)center{
     // θ=arctan[(y2-y0)/(x2-x0)]-arctan[(y1-y0)/(x1-x0)]；
    CGPoint centeredPoint1 = CGPointMake(first.x - center.x, first.y - center.y);
    CGPoint centeredPoint2 = CGPointMake(second.x - center.x, second.y - center.y);
    
    CGFloat firstAngle = angleBetweenOriginAndPointA(centeredPoint1);
    CGFloat secondAngle = angleBetweenOriginAndPointA(centeredPoint2);
    
    CGFloat rads = secondAngle - firstAngle;
    
    return rads;
}

/** 两点的距离 */
+(CGFloat)distanceBetweenPointA:(CGPoint)pointA AndPiontB:(CGPoint)pointB{
    // (y2-y1)²+(x2-x1)²=d²  sqrt(<#double#>)   pow(5, 2)
    CGFloat a = pow(pointB.x-pointA.x, 2);
    CGFloat b = pow(pointB.y-pointA.y, 2);
    
    return sqrt(a+b);
}

/** 某点和原点间的角度 */
+(CGFloat)angleBetweenOriginAndPointA:(CGPoint)p{
    return angleBetweenOriginAndPointA(p);
}

CGFloat angleBetweenOriginAndPointA(CGPoint p) {
    if (p.x  == 0) {
        return signA(p.y) * M_PI;
    }
    
    CGFloat angle = atan(-p.y / p.x); // '-' because negative ordinates are positive in UIKit
    
    // atan() is defined in [-pi/2, pi/2], but we want a value in [0, 2*pi]
    // so we deal with these special cases accordingly
    switch (quadrantForPointA(p)) {
        case 1:
        case 2: angle += M_PI; break;
        case 3: angle += 2* M_PI; break;
    }
    return angle;
}

/** 点的象限 */
NSInteger quadrantForPointA(CGPoint p) {
    if (p.x > 0 && p.y < 0) {
        return 0;
    } else if (p.x < 0 && p.y < 0) {
        return 1;
    } else if (p.x < 0 && p.y > 0) {
        return 2;
    } else if (p.x > 0 && p.y > 0)  {
        return 3;
    }
    return 0;
}

NSInteger signA(CGFloat num) {
    if (num == 0) {
        return 0;
    } else if (num > 0) {
        return 1;
    } else {
        return -1;
    }
}


@end
