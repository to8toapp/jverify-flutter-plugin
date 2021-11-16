//
//  UIButton+ButtonExpend.m
//  jverify
//
//  Created by 蔡建喜 on 2021/11/15.
//

#import "UIButton+ButtonExpend.h"

@implementation UIButton (ButtonExpend)

static char expandSizeKey;


- (void)expendWithWidth:(double)width andHeight:(double)height isPadding:(BOOL)isPadding{
    objc_setAssociatedObject(self, &expandSizeKey, @{
        @"width":[NSString stringWithFormat:@"%f",width],
        @"height":[NSString stringWithFormat:@"%f",height],
        @"isPadding":[NSNumber numberWithBool:isPadding]}, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect rect = [self expendRect];
    if (CGRectEqualToRect(rect, self.bounds)){
        return [super pointInside:point withEvent:event];
    }
    BOOL res = CGRectContainsPoint(rect, point)?YES:NO;
    return res;
}


- (CGRect)expendRect{
    NSDictionary *dic = objc_getAssociatedObject(self, &expandSizeKey);
    if (dic) {
        double width = [dic[@"width"] doubleValue];
        double height = [dic[@"height"] doubleValue];
        bool isPadding = dic[@"isPadding"];
        
        if (isPadding) {
            return CGRectMake(self.bounds.origin.x-width, self.bounds.origin.y-height, self.bounds.size.width+width*2, self.bounds.size.height+height*2);
        }else{
            return CGRectMake(self.bounds.origin.x-(width-self.bounds.size.width)/2.0, self.bounds.origin.y-(height-self.bounds.size.height)/2.0, width, height);
        }
    }else{
        return self.bounds;
    }
}

@end

