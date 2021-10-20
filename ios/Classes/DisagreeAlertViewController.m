//
//  DisagreeAlertViewController.m
//  jverify
//
//  Created by to8to on 2021/8/16.
//

#import "DisagreeAlertViewController.h"

static const NSString *kOperatorsProtocol = @"运营商服务与隐私协议";
static const NSString *kServiceProtocol = @"服务协议";
static const NSString *kPrivacyProtocol = @"隐私政策";

@interface DisagreeAlertViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@end

@implementation DisagreeAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewWidth = UIApplication.sharedApplication.keyWindow.frame.size.width - 30 * 2;
    _viewHeight = _viewWidth/1.4;
    _alertView = [self alertContenView];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_alertView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.frame = CGRectMake(30, (UIApplication.sharedApplication.keyWindow.frame.size.height-_viewHeight)/2.0, _viewWidth, _viewHeight);
    }];
    
}

- (UIView *)alertContenView{
        
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(UIApplication.sharedApplication.keyWindow.frame.size.width/2, UIApplication.sharedApplication.keyWindow.frame.size.height/2, 0, 0)];//315x226
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 6.0;
    alertView.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, _viewWidth, 28)];
    if (@available(iOS 8.2, *)) {
        titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0.067 green:0.067 blue:0.067 alpha:1];
    titleLabel.text = @"温馨提示";
    [alertView addSubview:titleLabel];
    
    
    
    UITextView  *textView = [[UITextView alloc] initWithFrame:CGRectMake(24, 69, (_viewWidth - 48), 65)];
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    NSString *protocol = [NSString stringWithFormat:@"阅读并同意%@、%@和%@可继续登录",[self operatorsProtocol], [self serviceProtocol], [self privacyProtocol]];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:protocol];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;// 字体的行间距
    [attributed addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithRed:0.53 green:0.55 blue:0.53 alpha:1], NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributed.string.length)];
    [self.privacy_linkDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self addProtocolAttributesFor:attributed withString:key withUrl:obj];
    }];
    textView.attributedText = attributed;
    textView.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    [alertView addSubview:textView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(40, 160, 106, 42);
    [cancelButton setTitleColor:[UIColor colorWithRed:0.53 green:0.55 blue:0.53 alpha:1] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorWithRed:0.957 green:0.96 blue:0.97 alpha:1];
    if (@available(iOS 8.2, *)) {
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    cancelButton.layer.cornerRadius = 4.0;
    [cancelButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(_viewWidth - 40 - 106, 160, 106, 42);
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"同意" forState:UIControlStateNormal];
    confirmButton.backgroundColor = [UIColor colorWithRed:0.14 green:0.777 blue:0.49 alpha:1];
    if (@available(iOS 8.2, *)) {
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    confirmButton.layer.cornerRadius = 4.0;
    [confirmButton addTarget:self action:@selector(agree) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:confirmButton];
    return alertView;
}

- (void)addProtocolAttributesFor:(NSMutableAttributedString *)attributed withString:(NSString *)str withUrl:(NSString *)url {
    NSRange range = [attributed.string rangeOfString:str];
    [attributed addAttributes:@{
                          NSLinkAttributeName: url,
                        }
                        range:range];
}

- (void)close{
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.frame = CGRectMake(UIApplication.sharedApplication.keyWindow.frame.size.width/2, UIApplication.sharedApplication.keyWindow.frame.size.height/2, 0, 0);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)agree{
    [self close];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.agreeCallBack();
    });
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    NSString *str = [textView.text substringWithRange:characterRange];
    self.tapPrivacyWithStringCallBack(str);
    return NO;
}

- (NSString *)operatorsProtocol{
    return self.privacy_linkDic.allKeys.firstObject;
}

- (NSString *)serviceProtocol{
    NSArray *arr = self.privacy_linkDic.allKeys;
    if (arr.count > 1) {
        return arr[1];
    }else {
        return kServiceProtocol;
    }
    
}

- (NSString *)privacyProtocol{
    NSArray *arr = self.privacy_linkDic.allKeys;
    if (arr.count > 2) {
        return arr[2];
    }else {
        return kPrivacyProtocol;
    }
}

@end
