//
//  IMMIPatientList.h
//  IMMI
//
//  Created by Nua Trans Media on 6/19/15.
//  Copyright (c) 2015 Nua Trans Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMIShowECG.h"
#import "IMMIDoctorPad.h"
#import "MBProgressHUD.h"
#import "NDHTMLtoPDF.h"
@interface IMMIPatientList : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDelegate,NDHTMLtoPDFDelegate,NSURLSessionDownloadDelegate>
{
    NSMutableData *responsedData;
    NSMutableArray *myobject;
    NSDictionary *dict;
    NSDictionary *dictTemp;
    NSString *Pid;
    NSMutableArray *muArrayImageCountStorage;
    NSMutableString *testextions;
    MBProgressHUD *hud;
    __weak IBOutlet UITableView *mytable;
    
    NSTimer* myTimer;
    
    NSString *booleanString;
    NSString *strManuallyKeys;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_headerName;
@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;
@property(nonatomic,strong)IMMIShowECG *ShowECG;
@property(nonatomic,strong)IMMIDoctorPad *ShowDoctorPad;
@property (strong,nonatomic) NSString *str_CheckingValues;//Checking Values
@property (strong,nonatomic) NSString *strPatientIDvalForRemove;
@property(strong,nonatomic)NSString *strreferralUserId;
- (IBAction)btn_backDismiss:(id)sender;

@property(strong,nonatomic) NSString *str_LocalAgeStore;
@property (weak, nonatomic) IBOutlet UIView *viw_AlertViewD;
@property (weak, nonatomic) IBOutlet UIView *viw_InnerAlertView;
@property (weak, nonatomic) IBOutlet UIWebView *webView_preloader;

@property (strong,nonatomic)NSString *extensionValues;
@property (strong,nonatomic)NSString *extensionNames;
@property(strong,nonatomic)NSString *str_Imagenames;

@property (strong,nonatomic)NSString *str_imageArrayCount;

@property (weak, nonatomic) IBOutlet UILabel *lblPatientTypesName;

@property (weak, nonatomic) IBOutlet UIView *viwPatientTypes;

@property (weak, nonatomic) IBOutlet UIImageView *imgTypeTrans;

@property(strong,nonatomic)NSString *patientOption;
@property (weak, nonatomic) IBOutlet UIImageView *imgAlertView;

-(void)getPatientListFromUrl :(NSString *)mailAddress;
-(void)getFileExtentions :(NSString *)ECGDataID;
@end
