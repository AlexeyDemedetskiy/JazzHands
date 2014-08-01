//
//  IFTTConditionalAnimation.h
//  Pods
//
//  Created by Alexey Demedetskiy on 29.07.14.
//
//

#import <Foundation/Foundation.h>

#import "IFTTTViewAnimation.h"

@interface IFTTTAnimation (IFTTConditionalAnimationProxy)

- (IFTTTAnimation*)enabledWhen:(BOOL (^)())predicateBlock;

@end