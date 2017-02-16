//
//  ViewController.h
//  immi
//
//  Created by Ravi on 29/11/16.
//  Copyright (c) 2016 ABI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentPatientTableViewCell.h"
#import "RegisterViewController.h"
#import "PatientListTableViewController.h"
@class RegisterViewController;
@interface ViewController : UIViewController<UITableViewDataSource,UITabBarDelegate,UIAlertViewDelegate>
{
    NSMutableArray *myobject;
    UITextField *userText;
    UIView *view;
    UIImageView *imgV;
    NSArray *imageArray;
    patientListTableViewController *patientList;
    RegisterViewController *reg;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *internetCalling;
@property(strong,nonatomic) NSMutableData *responsedData;
@property(strong,nonatomic) NSDictionary *dict;
@property(strong,nonatomic) NSDictionary *tmpDict;
@property(strong,nonatomic) NSDictionary *dictTemp;
@property(strong,nonatomic) NSString *Pid;
@property(strong,nonatomic) NSMutableArray *muArrayImageCountStorage;
@property(strong,nonatomic) NSMutableString *testextions;
@property(strong,nonatomic) NSData *nameDoctor;
@property (weak, nonatomic) IBOutlet UILabel *textz;
@property(strong,nonatomic)IBOutlet NSString *see;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *recent;
@property(strong,nonatomic) NSString *str_LocalAgeStore;
@property (weak, nonatomic) IBOutlet UIView *tableview;
@property (strong, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UILabel *doctorName;
@property (weak,nonatomic) NSString *docName;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@property (weak, nonatomic) IBOutlet UITableView *tables;
@property (weak, nonatomic) IBOutlet UIButton *patientList;
@property (weak, nonatomic) IBOutlet UILabel *lbl_deviceToken;
@property(strong,nonatomic)NSString *patientOption;
@property(strong,nonatomic)NSString *phoneNumber;
@end

