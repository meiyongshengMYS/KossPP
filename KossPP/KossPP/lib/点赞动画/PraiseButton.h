//
//  PraiseButton.h
//  TSBanPai
//
//  Created by wandong on 2018/4/10.
//  Copyright © 2018年 tingshan. All rights reserved.
//

#import <UIKit/UIKit.h>
//爆炸动画
@interface FireworksView : UIView

@property (nonatomic, strong) UIImage *particleImage;
@property (nonatomic, assign) CGFloat particleScale;
@property (nonatomic, assign) CGFloat particleScaleRange;

- (void)animate;

@end
/**使用方法
 - (void)praiseAction:(PraiseButton *)button {
 if (button.selected) {
 [button popInsideWithDuration:0.4f];
 }
 else {
 [button popOutsideWithDuration:0.5f];
 [button animate];
 }
 button.selected = !button.selected;
 }
 
 - (PraiseButton *)praiseButton {
 if (!_praiseButton) {
 _praiseButton = [[PraiseButton alloc] init];
 _praiseButton.frame = CGRectMake(0.f, 0.f, 60.f, 60.f);
 _praiseButton.particleImage = [UIImage imageNamed:@"blue_circle"];
 _praiseButton.particleScale = 0.05f;
 _praiseButton.particleScaleRange = 0.02f;
 [_praiseButton addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
 [_praiseButton setImage:[UIImage imageNamed:@"gray_like"] forState:UIControlStateNormal];
 [_praiseButton setImage:[UIImage imageNamed:@"blue_like"] forState:UIControlStateSelected];
 }
 return _praiseButton;
 }

 **/
//点赞按钮
@interface PraiseButton : UIButton
@property (nonatomic, strong) UIImage *particleImage;
@property (nonatomic, assign) CGFloat particleScale;
@property (nonatomic, assign) CGFloat particleScaleRange;

- (void)animate;
- (void)popOutsideWithDuration:(NSTimeInterval)duration;
- (void)popInsideWithDuration:(NSTimeInterval)duration;

@end
