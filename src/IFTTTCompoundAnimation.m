//
//  IFTTTCompoundAnimation.m
//  Pods
//
//  Created by Alexey Demedetskiy on 29.07.14.
//
//

#import "IFTTTCompoundAnimation.h"

@interface IFTTTCompoundAnimation : IFTTTAnimation

@property (nonatomic, copy) NSArray* childAnimations;

@end

@implementation IFTTTCompoundAnimation

- (void)animate:(NSInteger)time
{
    for (IFTTTAnimation* animation in self.childAnimations) {
        [animation animate:time];
    }
}

@end

@implementation IFTTTAnimation (IFTTTCompoundAnimation)

+ (IFTTTAnimation*)joinAnimations:(NSArray *)animations
{
    for (IFTTTAnimation* animation in animations) {
        NSParameterAssert([animation isKindOfClass:[IFTTTAnimation class]]);
    }
    
    IFTTTCompoundAnimation* compound = [IFTTTCompoundAnimation new];
    compound.childAnimations = animations;
    
    return compound;
}

- (IFTTTAnimation* )joinAnimation:(IFTTTAnimation*)animation
{
    return [IFTTTAnimation joinAnimations:@[self, animation]];
}

@end