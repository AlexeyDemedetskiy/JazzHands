//
//  IFTTTCompoundAnimation.h
//  Pods
//
//  Created by Alexey Demedetskiy on 29.07.14.
//
//

#import <Foundation/Foundation.h>
#import "IFTTTViewAnimation.h"

@interface IFTTTAnimation (IFTTTCompoundAnimation)

+ (IFTTTAnimation*)joinAnimations:(NSArray*)animations;
- (IFTTTAnimation*)joinAnimation:(IFTTTAnimation*)animation;

@end
