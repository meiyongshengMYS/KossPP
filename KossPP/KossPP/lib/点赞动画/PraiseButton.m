//
//  PraiseButton.m
//  TSBanPai
//
//  Created by wandong on 2018/4/10.
//  Copyright © 2018年 tingshan. All rights reserved.
//

#import "PraiseButton.h"

@interface FireworksView ()

@property (nonatomic, strong) CAEmitterLayer *explosionLayer;
@property (nonatomic, strong) CAEmitterCell *explosionCell;

@end

@implementation FireworksView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.clipsToBounds = NO;
    self.userInteractionEnabled = NO;
    /**
     *  爆炸效果
     */
    _explosionCell = [CAEmitterCell emitterCell];
    _explosionCell.name = @"explosion";
    _explosionCell.alphaRange = 0.2f; // 透明度改变的范围
    _explosionCell.alphaSpeed = -1.0f; // 透明度改变的速度
    _explosionCell.lifetime = 0.7f;
    _explosionCell.lifetimeRange = 0.3f;
    _explosionCell.birthRate = 0.f; // 粒子产生系数
    _explosionCell.velocity = 40.0f;
    _explosionCell.velocityRange = 10.0f;
    
    _explosionLayer = [CAEmitterLayer layer];
    _explosionLayer.name = @"emitterLayer";
    _explosionLayer.emitterShape = kCAEmitterLayerCircle; // 发射形状
    _explosionLayer.emitterMode = kCAEmitterLayerOutline;
    _explosionLayer.emitterSize = CGSizeMake(25.f, 0.f);
    _explosionLayer.emitterCells = @[_explosionCell];
    _explosionLayer.renderMode = kCAEmitterLayerOldestFirst; // 渲染模式
    _explosionLayer.masksToBounds = NO;
    [self.layer addSublayer:_explosionLayer];
    
}

//布局
- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置位置
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.explosionLayer.emitterPosition = center;
}

#pragma mark - Animate Methods
- (void)animate {
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        self.explosionLayer.beginTime = CACurrentMediaTime();
        //爆炸效果
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"emitterCells.explosion.birthRate"];
        animation.fromValue = @0;
        animation.toValue = @500;
        [self.explosionLayer addAnimation: animation forKey: nil];
    });
}

#pragma mark - Properties Method
- (void)setParticleImage:(UIImage *)particleImage {
    _particleImage = particleImage;
    self.explosionCell.contents = (id)[particleImage CGImage];
}

- (void)setParticleScale:(CGFloat)particleScale {
    _particleScale = particleScale;
    self.explosionCell.scale = particleScale;
}

- (void)setParticleScaleRange:(CGFloat)particleScaleRange {
    _particleScaleRange = particleScaleRange;
    self.explosionCell.scaleRange = particleScaleRange;
    
}

@end

@interface PraiseButton()

@property (nonatomic, strong) FireworksView *fireworksView;

@end

@implementation PraiseButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = NO;
    _fireworksView = [[FireworksView alloc] init];
    [self insertSubview:_fireworksView atIndex:0];
    
    self.particleImage = [UIImage imageNamed:@"blue_circle"];
    self.particleScale = 0.05f;
    self.particleScaleRange = 0.02f;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.fireworksView.frame = self.bounds;
    [self insertSubview:self.fireworksView atIndex:0];
}

#pragma mark - Methods
- (void)animate {
    [self.fireworksView animate];
}

//弹出
- (void)popOutsideWithDuration:(NSTimeInterval)duration {
    
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(2.0f, 2.0f); // 放大
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(0.8f, 0.8f); // 放小
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.0f, 1.0f); //恢复原样
        }];
    } completion:nil];
}
//弹进
- (void)popInsideWithDuration:(NSTimeInterval)duration {
    
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 2.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(0.7f, 0.7f); // 放小
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.0f, 1.0f); //恢复原样
        }];
    } completion:nil];
}

#pragma mark - Properties
//获取粒子图像
- (UIImage *)particleImage {
    return self.fireworksView.particleImage;
}
//设置粒子图像
- (void)setParticleImage:(UIImage *)particleImage {
    self.fireworksView.particleImage = particleImage;
}
//获取缩放
- (CGFloat)particleScale {
    return self.fireworksView.particleScale;
}
//设置缩放
- (void)setParticleScale:(CGFloat)particleScale {
    self.fireworksView.particleScale = particleScale;
}
//获取缩放范围
- (CGFloat)particleScaleRange {
    return self.fireworksView.particleScaleRange;
}
//设置缩放范围
- (void)setParticleScaleRange:(CGFloat)particleScaleRange {
    self.fireworksView.particleScaleRange = particleScaleRange;
}

@end
