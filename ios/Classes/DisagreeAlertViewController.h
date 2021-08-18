//
//  DisagreeAlertViewController.h
//  jverify
//
//  Created by to8to on 2021/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DisagreeAlertViewController : UIViewController

@property(nonatomic, copy) void (^agreeCallBack)(void);
@property(nonatomic, copy) void (^tapPrivacyWithStringCallBack)(NSString *);
@property(nonatomic, copy) NSDictionary *privacy_linkDic;
@property(nonatomic, copy) NSAttributedString *privacyAttributedString;

@end

NS_ASSUME_NONNULL_END
