//
//  LoginViewController.m
//  immi
//
//  Created by Ravi on 02/12/16.
//  Copyright © 2016 ABI. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+_emailValidation_.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIView+Toast.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "ViewController.h"
#import "NSString+_emailValidation_.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define BaseURLForSerVer2 @"http://192.168.7.150:8080/IMMICloud/"
#define BaseURLUserLogin @"user/loginuser"
@interface LoginViewController ()
{
    Reachability *reachable;
}

@end

@implementation LoginViewController
@synthesize iMMEmail2,iMM2;
- (void)viewDidLoad {
    [super viewDidLoad];
     [self MaterialDesign];
     _lbl_deviceToken.text = @"9845697";
    //[self preLoaderAnimation];
    _iMMEmail.delegate =self;
    _iMMiPassword.delegate = self;
    //iMMEmail2 = _iMMEmail.text;
   // iMM2 =_iMMiPassword.text;
    
    //Changing Border Color of the textFields
    _iMMEmail.layer.cornerRadius=8.0f;
    _iMMEmail.layer.masksToBounds=YES;
    _iMMEmail.layer.borderWidth=2.0f;
    _iMMEmail.layer.borderColor=[[UIColor colorWithRed:150/255 green:97/255 blue:5/255 alpha:1]CGColor];
    _iMMiPassword.layer.cornerRadius=8.0f;
    _iMMiPassword.layer.masksToBounds=YES;
    _iMMiPassword.layer.borderWidth=2.0f;
    _iMMiPassword.layer.borderColor=[[UIColor colorWithRed:(150/255) green:(97/255) blue:(5/255) alpha:1]CGColor];
    //Checking internet Status
  if(![self internetServiceAvailable])
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"No Internet" message:@"Please Turn on Cellular data or Wifi for this app in Settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
  
}
    


-(BOOL)internetServiceAvailable
{
    return [[Reachability reachabilityForInternetConnection]currentReachabilityStatus];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
        if([[segue identifier]isEqualToString:@"source"])
            
        {
            UINavigationController *nav =segue.destinationViewController;
            ViewController *viewer = (ViewController *)nav.topViewController;
          
            viewer.see=iMMEmail2;
            viewer.phoneNumber=iMM2;
 
        }
    }*/

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
if(errorAlert.tag==1  || errorAlert.tag==2  || errorAlert.tag==4 ||  errorAlert.tag==3)
{
    
    return NO;
}
    
    if([identifier isEqual:@"say"])
    {
       //[self dataValueFromServer:_iMMEmail.text PhoneNO:_iMMiPassword.text];
        //viewControle.see=[NSString stringWithFormat:@"Dr. %@",jsonRetName];
        [[NSUserDefaults standardUserDefaults]setObject:jsonRetName forKey:@"Hname"];
        [[NSUserDefaults standardUserDefaults]setObject:_iMMEmail.text forKey:@"Hemail"];
    return YES;
    }
    return NO;
}
- (IBAction)iMMiSuubmitLogin:(id)sender {
    [self MaterialDesign];
    [self.iMMEmail resignFirstResponder];
    [self.iMMiPassword resignFirstResponder];
    //iMMEmail2 = _iMMEmail.text;
   // NSLog(@"This is result%@", iMMEmail2);
    //iMM2=_iMMiPassword.text;
     //NSLog(@"phone: %@",iMM2);
    //Animation
    UIImage *Alertimage =[UIImage imageNamed:@"Alertlogo.png"];
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [animate setToValue:[NSNumber numberWithFloat:0.0f]];
    [animate setFromValue:[NSNumber numberWithDouble:M_PI/16]];
    [animate setDuration:0.1];
    [animate setRepeatCount:NSUIntegerMax];
    [animate setAutoreverses:YES];
    //Checking internet
    if (![self internetServiceAvailable])
    {
        errorAlert = [[UIAlertView alloc]initWithTitle:@"No Internet" message:@"Please Turn on Cellular data or wifi for this app in settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlert show];
        errorAlert.tag=6;
    }
    if([_iMMEmail.text isEqual:@""])
    {
       //Alert View if Empty email
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        imgView.contentMode=UIViewContentModeTop;
        [imgView setImage:Alertimage];
        
       errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Email field is Empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlert show];
        //Adding images to the Alert view
        
         [[errorAlert layer] addAnimation:animate forKey:@"iconShake"];
        //ios7.0 and above version
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [errorAlert setValue:imgView forKey:@"accessoryView"];
        }else{
            
            [errorAlert addSubview:imgView];
        }
        //Changing the tint color of the text
       [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertView class]]] setTintColor:[UIColor greenColor]];
      [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]] setTintColor:[UIColor greenColor]];
        [errorAlert show];
        AudioServicesPlaySystemSound(1352) ;
        errorAlert.tag=1;
    }
    else{
    if([_iMMEmail.text  isValidEmail])
    {
       if([_iMMiPassword.text isEqual:@""])
       {
           errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Phone field is Empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
           [errorAlert show];
           //Adding images to the Alert view
           
           UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 50, 50)];
           imgView.contentMode=UIViewContentModeCenter;
           [imgView setImage:Alertimage];
           [[imgView layer] addAnimation:animate forKey:@"iconShake"];
           //ios7.0 and above version
           if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
               [errorAlert setValue:imgView forKey:@"accessoryView"];
           }else{
               
               [errorAlert addSubview:imgView];
           }
           //Changing the tint color of the text
          // [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertView class]]] setTintColor:[UIColor greenColor]];
           [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]] setTintColor:[UIColor greenColor]];
           [errorAlert show];
           AudioServicesPlaySystemSound(1352) ;
           errorAlert.tag=2;
       }
        else
        {
            
            [self preLoaderAnimation];
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //this will start the image loading in bg
            dispatch_async(concurrentQueue, ^{
                //Here Login APi
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.7.150:8080/IMMICloud/user/loginuser"]];
                // Specify that it will be a POST request
                request.HTTPMethod = @"POST";
                // This is how we set header fields
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                // Convert your data and set your request's HTTPBody property
                NSString *stringData = [NSString stringWithFormat:@"{\"emailid\":\"%@\",\"phone\":\"%@\",\"device_token\":\"%@\",\"os_type\":\"%@\"}",_iMMEmail.text,_iMMiPassword.text,@"12345678",@"ios"];
                NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
                request.HTTPBody = requestBodyData;
                NSData *strResponseData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    @try {
                        
                        if (strResponseData!=nil)
                        {
                            NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:strResponseData options:NSJSONReadingMutableContainers error:nil];
                            NSLog(@"LIST: %@", dictJson);
                            NSString *jsonRet = [dictJson valueForKey:@"description"];
                            jsonRetName= [dictJson valueForKey:@"name"];
                            NSString *jsonRetStatus= [dictJson valueForKey:@"status"];
                            jsonRetUserRole= [dictJson valueForKey:@"userRole"];
                            NSArray *jsonRetRoutine = [dictJson valueForKey:@"routineResults"];
                            //NSString *jsonRetUserName= [dictJson valueForKey:@"username"];
                            //NSString *jsonRetFacilityName = [dictJson valueForKey:@"facilityName"];
                            NSLog(@"1.Patient Name:%@",jsonRetName);
                            if ([jsonRetUserRole isEqualToString:@"GENERAL_HOSPITAL"])
                            {
                                [[NSUserDefaults standardUserDefaults]setObject:@"RegisterVal" forKey:@"Register"];
                                [[NSUserDefaults standardUserDefaults]setObject:jsonRetName forKey:@"Hname"];
                                [[NSUserDefaults standardUserDefaults]setObject:jsonRetStatus forKey:@"Hstatus"];
                                [[NSUserDefaults standardUserDefaults]setObject:jsonRetUserRole forKey:@"HuserRole"];
                                [[NSUserDefaults standardUserDefaults]setObject:_iMMEmail.text forKey:@"Hemail"];
                                [[NSUserDefaults standardUserDefaults]setObject:jsonRetRoutine forKey:@"Hroutine"];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                                
                                //_lbl_Name.text = [NSString stringWithFormat:@"Dr. %@",jsonRetName];
                                // NSLog(@"Patient Name:%@",jsonRetName);
                                //viewControle.see=[NSString stringWithFormat:@"Dr. %@",jsonRetName];
                                [self performSelector:@selector(stopPreloader) withObject:nil afterDelay:5.0f];
                                [self shouldPerformSegueWithIdentifier:@"say" sender:nil];
                                // NSLog(@"PatientName:%@",[NSString stringWithFormat:@"Dr. %@",jsonRetName]);
                            }
                            
                            else
                            {
                                errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Please Enter Registered Email Address and Registered Phone Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                UIImage *Alertimage =[UIImage imageNamed:@"Alertlogo.png"];
                                UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
                                imgView.contentMode=UIViewContentModeCenter;
                                [imgView setImage:Alertimage];
                                [errorAlert addSubview:imgView];
                                [self performSelector:@selector(stopPreloader) withObject:nil afterDelay:2.0];
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                NSLog(@"Wrong User");
                                errorAlert.tag=3;
                                [errorAlert show];
                                AudioServicesPlaySystemSound (1352);
                                
                                // [self dismissViewControllerAnimated:NO completion:nil];
                                
                            }
                            
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Error Value :%@",[exception description]);
                    }
                    @finally
                    {
                        NSLog(@"Reached");
                    }
                    
                    
                });
                
                
            });
            
        }
    }
    else
        {
            errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please Enter Valid Email Address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [errorAlert show];
            //Adding images to the Alert view
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(160.5, 27, 50, 50)];
            imgView.contentMode=UIViewContentModeCenter;
            [imgView setImage:Alertimage];
            [[imgView layer] addAnimation:animate forKey:@"iconShake"];
            //ios7.0 and above version
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
                [errorAlert setValue:imgView forKey:@"accessoryView"];
            }else{
                
                [errorAlert addSubview:imgView];
            }
            //Changing the tint color of the text
            [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertView class]]] setTintColor:[UIColor greenColor]];
            [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]] setTintColor:[UIColor greenColor]];
            [errorAlert show];
            AudioServicesPlaySystemSound(1352) ;
            errorAlert.tag=4;
        }
        }
 
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.iMMEmail)
    {
        [self.iMMiPassword becomeFirstResponder];
    }
    else
    {
        [self.iMMiPassword resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    /* [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];*/
}

- (void)keyboardWillShow:(NSNotification *)note {
    // create custom button
    doneButton.hidden = NO;
    doneButton   = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setTitle:@"return" forState:UIControlStateNormal];
    // [doneButton setImage:[UIImage imageNamed:@"doneButtonPressed.png"] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(doneButton) forControlEvents:UIControlEventTouchUpInside];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *keyboardView = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] firstObject];
            [doneButton setFrame:CGRectMake(0, keyboardView.frame.size.height-30, 106, 53)];
            [keyboardView addSubview:doneButton];
            [keyboardView bringSubviewToFront:doneButton];
        });
    }else {
        // locate keyboard view
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
            UIView* keyboard;
            for(int i=0; i<[tempWindow.subviews count]; i++) {
                keyboard = [tempWindow.subviews objectAtIndex:i];
                // keyboard view found; add the custom button to it
                if([[keyboard description] hasPrefix:@"UIKeyboard"] == YES)
                    [keyboard addSubview:doneButton];
            }
        });
    }
}
-(void)doneButton
{
    [self.iMMiPassword resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)dataValueFromServer :(NSString *)UserName PhoneNO:(NSString *)phoneNo
{
    
}

-(void)process_coupon:(NSData *)response  {
    
    
}
-(void)preLoaderAnimation
{
    if (![self internetServiceAvailable])
    {
        
        [self stopPreloader];
       // UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"No Internet" message:@"Please Turn on Cellular data or Wifi for this app in Settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
       // [errorAlert show];
    }
    else
    {
        imgV =[[UIImageView alloc] initWithFrame:CGRectMake(150,300,50,50)];
        // [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        
        
        imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"rotate1.png"],[UIImage imageNamed:@"rotate2.png"],[UIImage imageNamed:@"rotate3.png"],[UIImage imageNamed:@"rotate4.png"],[UIImage imageNamed:@"rotate5.png"],[UIImage imageNamed:@"rotate6.png"],[UIImage imageNamed:@"rotate7.png"],[UIImage imageNamed:@"rotate8.png"],[UIImage imageNamed:@"rotate9.png"],[UIImage imageNamed:@"rotate10.png"],[UIImage imageNamed:@"rotate11.png"],[UIImage imageNamed:@"rotate12.png"],[UIImage imageNamed:@"rotate13.png"],[UIImage imageNamed:@"rotate14.png"],[UIImage imageNamed:@"rotate15.png"],[UIImage imageNamed:@"rotate16.png"],[UIImage imageNamed:@"rotate17.png"],[UIImage imageNamed:@"rotate18.png"],[UIImage imageNamed:@"rotate19.png"],[UIImage imageNamed:@"rotate20.png"],[UIImage imageNamed:@"rotate21.png"],[UIImage imageNamed:@"rotate22.png"],[UIImage imageNamed:@"rotate23.png"],[UIImage imageNamed:@"rotate24.png"],[UIImage imageNamed:@"rotate25.png"],[UIImage imageNamed:@"rotate26.png"],[UIImage imageNamed:@"rotate27.png"],[UIImage imageNamed:@"rotate28.png"],[UIImage imageNamed:@"rotate29.png"],[UIImage imageNamed:@"rotate30.png"],[UIImage imageNamed:@"rotate32.png"],[UIImage imageNamed:@"rotate33.png"],[UIImage imageNamed:@"rotate34.png"],nil];
       imgV.animationImages = imageArray;
        imgV.animationDuration = 1.0f;
        imgV.animationRepeatCount =NSUIntegerMax;
        [self.view addSubview:imgV];
      //  [self.view setBackgroundColor:[UIColor lightGrayColor] ];
        [imgV startAnimating];
        
        UIBlurEffect *blur =[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *visual = [[UIVisualEffectView alloc]initWithEffect:blur];
        visual.frame = self.view.frame;
           }
}
-(void)stopPreloader
{

   // [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    imgV.hidden = YES;
    [imgV stopAnimating];
    imgV.image = [imageArray objectAtIndex:0];
    [self.view willRemoveSubview:(UIImageView *)imgV];
    
  
   
}

-(void)MaterialDesign
{
    _iMMiSubmit.layer.shadowOffset = CGSizeMake(0,1);
    _iMMiSubmit.layer.shadowRadius = 5;
    _iMMiSubmit.layer.shadowOpacity = 0.7;
}

@end
