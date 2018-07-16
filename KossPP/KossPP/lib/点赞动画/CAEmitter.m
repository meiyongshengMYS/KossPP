//
//  CAEmitter.m
//  KossPP
//
//  Created by 梅 on 2018/7/14.
//  Copyright © 2018年 mei. All rights reserved.
//

#import "CAEmitter.h"

@implementation CAEmitter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    //发射点的位置
    snowEmitter.emitterPosition = CGPointMake(self.bounds.size.width * 0.5, -30);
    //
    snowEmitter.emitterSize = CGSizeMake(self.bounds.size.width * 2.0, 0.0);
    snowEmitter.emitterShape = kCAEmitterLayerLine;
    snowEmitter.emitterMode = kCAEmitterLayerOutline;
    
    snowEmitter.shadowColor = [UIColor whiteColor].CGColor;
    snowEmitter.shadowOffset = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowRadius = 0.0;
    snowEmitter.shadowOpacity = 1.0;
    
    CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
    
    snowCell.birthRate = 1.0; //每秒出现多少个粒子
    snowCell.lifetime = 120.0; // 粒子的存活时间
    snowCell.velocity = -10; //速度
    snowCell.velocityRange = 10; // 平均速度
    snowCell.yAcceleration = 2;//粒子在y方向上的加速度
    snowCell.emissionRange = 0.5 * M_PI; //发射的弧度
    snowCell.spinRange = 0.25 * M_PI; // 粒子的平均旋转速度
    snowCell.contents = (id)[UIImage imageNamed:@"雪花"].CGImage;
    snowCell.color = [UIColor colorWithRed:0.6 green:0.658 blue:0.743 alpha:1.0].CGColor;
    
    snowEmitter.emitterCells = @[snowCell];
    
    [self.layer insertSublayer:snowEmitter atIndex:0];

}
@end
