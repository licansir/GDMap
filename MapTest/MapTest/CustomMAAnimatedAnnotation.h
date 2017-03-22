//
//  CustomMAAnimatedAnnotation.h
//  iOS_movingAnnotation
//
//  Created by 翟安娜 on 17/3/15.
//  Copyright © 2017年 yours. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustomMAAnimatedAnnotation : MAAnimatedAnnotation

// 车是否跑动
@property (nonatomic ,assign) BOOL isRun;

// 所记录车刚刚启动的位置
@property (nonatomic ,assign)  NSInteger carIndex;
@end
