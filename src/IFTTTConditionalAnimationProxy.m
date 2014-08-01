//
//  IFTTConditionalAnimation.m
//  Pods
//
//  Created by Alexey Demedetskiy on 29.07.14.
//
//

#import "IFTTTConditionalAnimationProxy.h"

@interface IFTTTConditionalAnimationProxy : IFTTTAnimation

@property (nonatomic, copy) BOOL (^predicateBlock)();
@property (nonatomic, readonly) IFTTTAnimation* childAnimation;

- (instancetype)initWithChildAnimation:(IFTTTAnimation*)childAnimation;

@end

@implementation IFTTTConditionalAnimationProxy

- (instancetype)initWithChildAnimation:(IFTTTAnimation*)childAnimation
{
    NSParameterAssert(childAnimation != nil);
    
    self = [super init];
    if (self == nil) return nil;
    
    _childAnimation = childAnimation;
    
    return self;
}

- (void)animate:(NSInteger)time
{
    if (self.predicateBlock != nil) {
        if (self.predicateBlock() == YES) {
            [self.childAnimation animate:time];
        }
    }
}

@end

@implementation IFTTTAnimation (IFTTConditionalAnimationProxy)

- (IFTTTAnimation *)enabledWhen:(BOOL (^)())predicateBlock
{
    IFTTTConditionalAnimationProxy* proxy = [[IFTTTConditionalAnimationProxy alloc] initWithChildAnimation:self];
    proxy.predicateBlock = predicateBlock;
    
    return proxy;
}

@end