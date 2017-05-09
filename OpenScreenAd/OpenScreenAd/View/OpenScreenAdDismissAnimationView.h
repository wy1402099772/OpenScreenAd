//
//  OpenScreenAdDismissAnimationView.h
//  Pods
//
//  Created by wyan assert on 2017/4/20.
//
//

#import <UIKit/UIKit.h>

typedef void (^OSA_CompletionBlock)();

@interface OpenScreenAdDismissAnimationView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGPoint dismissEndPoint;

- (void)startDismissAnimation:(OSA_CompletionBlock)block;
- (void)revertDismissAnimation:(OSA_CompletionBlock)block;

@end
