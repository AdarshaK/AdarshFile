//
//  LoginViewController.h
//  immi
//
//  Created by Ravi on 02/12/16.
//  Copyright © 2016 ABI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface LoginViewController : UIViewController<NSURLConnectionDelegate,UITextFieldDelegate>
{
    UIButton *doneButton;
    ViewController *viewControle;
    UIView *view;
    UIImageView *imgV;
    NSArray *imageArray;
    NSString *jsonRetName;
    NSString *jsonRetUserRole;
    UIAlertView *errorAlert;
    NSInteger tag;
   
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_deviceToken;
@property (strong,nonatomic)IBOutlet  NSString *iMM2;
@property (strong,nonatomic)IBOutlet  NSString *iMMEmail2;
@property (weak, nonatomic) IBOutlet UITextField *iMMEmail;
@property (weak, nonatomic) IBOutlet UITextField *iMMiPassword;

@property (weak, nonatomic) IBOutlet UIButton *iMMiSubmit;

@property (weak, nonatomic) IBOutlet UIView *viw_AlertViewD;
@property (weak, nonatomic) IBOutlet UIImageView *imgAlertView;
@end
