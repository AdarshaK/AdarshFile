//
//  RegisterViewController.h
//  immi
//
//  Created by Ravi on 06/12/16.
//  Copyright © 2016 ABI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMIComplaints.h"
#import "ViewController.h"
@interface RegisterViewController : UIViewController<UINavigationBarDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    CALayer *glayer,*alayer,*dlayer,*clayer,*elayer,*blayer,*player;
    NSArray *campName;
    IMMIComplaints *complaints;
    UIView *viewblack,*genderV,*cameraV,*dateOFBirth,*dateview;
    UIButton *button1,*button2,*button3,*btnM,*btnF,*btnO,*btnC,*btnG,*doneButton,*addSymptomS;
    NSLayoutConstraint *descriptionHeightConstraint;
    UITableView *table;
    UIView *campView;
    UIButton *campB;
    UITapGestureRecognizer *gestureCam , *gestureRecognizer,*gestureDate,*gestureCamp,*gestureKey;
    UIButton *doneButtons;
    UIDatePicker *dataPicker;
    NSDictionary *dict;
    
}

-(void)layoutSubviews;
-(void)CustomViews;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *ECGLabel;
@property (strong,nonatomic)NSArray *results;
@property (weak, nonatomic) IBOutlet UIScrollView *rScrollV;
@property (weak, nonatomic) IBOutlet UIView *PatientView;
@property (weak, nonatomic) IBOutlet UIView *contactNoView;
@property (weak, nonatomic) IBOutlet UIView *dateOFBirthView;
@property (weak, nonatomic) IBOutlet UIView *SymptomsView;
@property (weak, nonatomic) IBOutlet UIView *ECGFileView;
@property (weak, nonatomic) IBOutlet UIView *AgeView;
@property (weak, nonatomic) IBOutlet UIView *GenderView;
@property (weak, nonatomic) IBOutlet UILabel *patientLabel;
@property (weak, nonatomic) IBOutlet UITextField *patientName;
@property (weak, nonatomic) IBOutlet UITextField *genderName;
@property (weak, nonatomic) IBOutlet UITextField *dateofBirth;
@property (weak, nonatomic) IBOutlet UITextField *Age;
@property (weak, nonatomic) IBOutlet UITextField *ContactNumber;
@property (weak, nonatomic) IBOutlet UIButton *addSymptoms;
@property (weak, nonatomic) IBOutlet UIButton *ECGFile;
@property (weak, nonatomic) IBOutlet UITextView *SymptomsTexView;
@property (weak, nonatomic) IBOutlet UIImageView *iMageView;
@property (weak, nonatomic) IBOutlet UIToolbar *RegisterPatient;
@property (weak, nonatomic) IBOutlet UILabel *symptomsLabel;
@property (weak, nonatomic) IBOutlet UIButton *genderClick;
@property (weak, nonatomic) IBOutlet UIButton *dateOfBirth;
@property (weak, nonatomic) IBOutlet UILabel *dateOfB;
@property (weak, nonatomic) IBOutlet UILabel *genderB;
@property (weak, nonatomic) IBOutlet UIToolbar *registerPatient;
@property (strong, nonatomic) NSString *regist;
@end
