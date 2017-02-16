//
//  ViewController.m
//  immi
//
//  Created by Ravi on 29/11/16.
//  Copyright (c) 2016 ABI. All rights reserved.
//


#import "RecentPatientTableViewCell.h"
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
#define IMMILIFEPATIENTLIFEOPTION @"OptionPatient"
#define BaseURLForSerVer2 @"http://192.168.7.150:8080/IMMICloud/patient/addPatientApp"
#define BaseURLPatientList @"referral/queryReferralsFIFO/"
#define BaseURLRoutinePatientList @"referral/queryRoutineReferralsFIFO"
#define BaseURLCampPatientList @"referral/queryCampReferralsFIFO"
//http://immi.heartsapp.org/DemoCloud/patient/addPatientApp
@interface ViewController ()

@end
@implementation ViewController
@synthesize doctorName;
@synthesize docName,userText,see,phoneNumber;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self materialDesign];
    
    _tables.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     doctorName.text=[NSString stringWithFormat:@"Dr. %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Hname"]];
    //taking name and email from login view.
    NSLog(@"Patient Name:%@",[NSString stringWithFormat:@"Dr. %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Hname"]]);
    NSLog(@"email %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Hemail"]);
    //docName = doctorName.text;
    // Do any additional setup after loading the view, typically from a nib.
    //adding image to the bar button
   // [self.navigationItem.backBarButtonItem setTitle:@""];
    NSLog(@"DocName:%@",doctorName.text);
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem ]setBackBarButtonItem:newButton];
    
    _Pid=@"list";
    myobject = [[NSMutableArray alloc]init];
    [self getPatientListFromUrl];
    if (![self internetServiceAvailable])
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"No Internet" message:@"You Can Turn on Cellular data or wifi for this app in settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlert show];
        
    }
    else
    {
        
    }
    
  //  [self hideTableView];
    
}
/*-(void)viewDidAppear:(BOOL)animated
{
    //Adding custom Label if there is no recent patient to display
   // NSLog(@"Hello Result %@",see);
  //  doctorName.text=[NSString stringWithFormat:@"Dr. %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Hname"]];
  //   NSLog(@"Phone Number: %@",phoneNumber);
   
}*/
-(void)viewDidAppear:(BOOL)animated
{
    doctorName.text=[NSString stringWithFormat:@"Dr. %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Hname"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear
{
    [_tables reloadData];
    
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqual:@"register"] ||[identifier isEqual:@"patientList"]){
        return YES;
    }
    return NO;
}
- (IBAction)internetCalling:(id)sender {
    NSString *phone;
    NSURL *phoneURL;

    if(doctorName.text ==[NSString stringWithFormat:@"Dr. %@",see])
    {
      phone  = [[NSString alloc]initWithFormat:@"tel:%@",phoneNumber];
       phoneURL =[[NSURL alloc]initWithString:phone];
        [[UIApplication sharedApplication]openURL:phoneURL];
           }
    else
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel:9008415865"]];
    }
   // phoneURL =[[NSURL alloc]initWithString:phone];
  //  [[UIApplication sharedApplication]openURL:phoneURL];
    //phone  = [[NSString alloc]initWithFormat:@"tel:%@",phoneNumber];
  //  NSLog(@"Phone Number: %@",phone);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\nPhone call placed" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.backgroundColor = [UIColor clearColor];
   [self presentViewController:alert animated:YES completion:nil];
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
    alert.view.tintColor=[UIColor whiteColor];
    
}
-(void)dismissAlert:(UIAlertController *)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *) getDateFromUnixFormat:(NSString *)unixFormat
{
    double unixTimeStamp = [unixFormat doubleValue];
    NSTimeInterval timeInterval=unixTimeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setLocale:[NSLocale currentLocale]];
    [dateformatter setDateFormat:@"dd-MMM-yyyy HH:mm a"];
    NSString *dateString=[dateformatter stringFromDate:date];
    
    return dateString;
    
}
/*- (IBAction)unwindFromRegisterViewController:(UIStoryboardSegue *)segue

{
    if([segue.identifier isEqual:@"receive"])
    {
        
      //  complaints  = (IMMIComplaints *)segue.sourceViewController;
       // _label.text = complaints.result;
       // _label.textColor = [UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:136.0/255.0 alpha:1];
      //  _label.minimumFontSize = 15;
    }
}*/
-(void)getPatientListFromUrl
{
    
   [self preLoaderAnimation];
    NSString *strEmailAddress = [[NSUserDefaults standardUserDefaults]valueForKey:@"Hemail"];
    NSLog(@"------>%@",strEmailAddress);
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
       // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.7.150:8080/IMMICloud/referral/campsQueryUrlApp"]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.7.150:8080/IMMICloud/patient/queryPatientsApp/"]];
        // Specify that it will be a POST request
        request.HTTPMethod = @"POST";
        // This is how we set header fields
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        // Convert your data and set your request's HTTPBody property
        int a=0,b=0;
        
       NSString *stringData = [NSString stringWithFormat:@"{\"username\":\"%@\",\"itemsPerPage\":\"%@\",\"pageNumber\":\"%@\"}",strEmailAddress,[NSNumber numberWithInteger:b],[NSNumber numberWithInteger:a]];
        //NSString *stringData = [NSString stringWithFormat:@"{\"userName\":\"%@\"}\"",strEmailAddress];
        
      //  NSDictionary *dict = @{@"username":@"",@"itemsPerPage":@0,@"pageNumber":@0 };
       
        NSLog(@"%@",stringData);
        NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = requestBodyData;
        NSData *strResponseData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        [self jsonValueProgress:strResponseData];
            
        });
    });
  
   
  /* NSString *strEmailAddress = [[NSUserDefaults standardUserDefaults]valueForKey:@"Hemail"];
    [self preLoaderAnimation];
    int a,b;
    a=b=0;
    NSDictionary *dict = @{@"userName":@"hh@gmail.com"};
    NSData *data =[NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil ];
   
   // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.7.150:8080/IMMICloud/patient/queryPatientsApp/"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    NSURL *url = [NSURL URLWithString:@"http://192.168.7.150:8080/IMMICloud/referral/campsQueryUrlApp"];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 //  [request addRequestHeader:@"User-Agent" value:@"iOS"];
    [request setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:data];
    
    NSURLResponse * response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
   NSString *str1 =[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSArray *responseArray = [responseData valueForKey:@"list"];
  //  NSLog(@"%@",responseArray );
    NSLog(@"List :%@",str1);
    NSLog(@"Dict:%@",dict);*/
}
-(void)getFileExtentions :(NSString *)ECGDataID
{
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        
        //NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@file/downloadImage/?imageInstanceUid=%@",BaseURLForSerVer2,ECGDataID]];
        NSURL* fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@file/downloadImage/?imageInstanceUid=%@",BaseURLForSerVer2,ECGDataID]];
        //NSURLRequest* fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileUrl];
        NSURLRequest* fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileUrl cachePolicy:0 timeoutInterval:.1];
        NSError* error = nil;
        NSURLResponse* response = nil;
        NSData* fileData = [NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:&response error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* mimeType = [response MIMEType];
            NSLog(@"----->%@",mimeType);
        });
    });
}
-(void)jsonValueProgress:(NSData *)responsData
{
    
    @try {
        if (responsData!=nil)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:responsData options:kNilOptions error:&jsonParsingError];
            if (jsonParsingError) {
                NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
            } else {
                NSLog(@"LIST: %@", jsonObjects);
            }
            NSString *statusCodeValue = [[jsonObjects objectForKey:@"result"] valueForKey:@"status"];
           NSLog(@"Status Code:%@",statusCodeValue);
            
            if([statusCodeValue isEqualToString:@"200"])
            {
                
                // [self performSelector:@selector(stopPreloader) withObject:nil afterDelay:1.0]; referralId
                
                [self stopPreloader];
                
                NSArray *responseArray = [jsonObjects valueForKey:@"list"];
                NSLog(@"response Array %@",responseArray);
                if(responseArray.count!=0)
                {
                    
                 //NSString *strmanuallyAssignedList = [jsonObjects valueForKey:@"manualAssignedReferralUserId"];
                   // NSString *strManuallyCheck = [jsonObjects valueForKey:@"manuallyAssignedList"];
                 //   NSLog(@"<------------------manuallyAssignedList------------------------->%@",strManuallyCheck);
                    
                    
                  //  _str_CheckingValues = [NSString stringWithFormat:@"%@",[[[[responseArray objectAtIndex:0] valueForKey:@"immiReferralTb"] valueForKey:@"immiPatientTb"] valueForKey:@"immiPatinetId"]];
                    for (id myArrayElement in responseArray)
                    {
                        NSString *strGetPatientid = [myArrayElement valueForKey:@"immiPatinetId"];
                        [[NSUserDefaults standardUserDefaults]setObject:strGetPatientid forKey:@"patientId"];
                        NSLog(@"strgetPatient Id%@",strGetPatientid);
                        //Patient ID Value
                        NSString *strGetGender = [[myArrayElement valueForKey:@"immiPersonTb"]valueForKey:@"gender"];//Patient Gender
                        NSString *strDob = [[myArrayElement valueForKey:@"immiPersonTb"] valueForKey:@"dateOfBirth"];
                        NSString *strCreatedDate = [myArrayElement  valueForKey:@"createdDate"];
                        NSString *strPaitentAge =[myArrayElement  valueForKey:@"patientAge"];
                        
                        NSLog(@"---->PaitentAge print<-----%@",strPaitentAge);
                       _dict = [NSDictionary dictionaryWithObjectsAndKeys:strGetPatientid,@"patientId",strGetGender,@"gender",strDob,@"dateOfBirth",strCreatedDate,@"createdDate",strPaitentAge,@"patientAge",nil];
                        [self shouldPerformSegueWithIdentifier:@"patientList" sender:nil];
                      //  [_myobject addObject:_dict];
                        NSDictionary *dictct = @{@"patient_id":@"1111111",@"Patient_name":@"222222"};
                        [myobject addObject:_dict];
                      //  [[NSUserDefaults standardUserDefaults]setObject:_myobject forKey:@"dictct"];
                        NSLog(@"Array Content:%lu",(unsigned long)myobject.count);
                        [_tables reloadData];
                    
                    
                    }
                   
                }
                else
                {
                    [self hideTableView];
                    _tableview.hidden=YES;
                    _patientList.hidden=YES;
                    _textz.hidden=YES;
                    
                }
                
                
            }
            else
            {
                
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
    
    
    
}
- (IBAction)registerPatient:(id)sender {
   
   
}


-(BOOL)internetServiceAvailable
{
    
    return [[Reachability reachabilityForInternetConnection]currentReachabilityStatus];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [myobject count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *CellIdentifier = @"Cell";
    RecentPatientTableViewCell *cell = (RecentPatientTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell = [[RecentPatientTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   
    }
    NSDictionary *tmpDict = [myobject objectAtIndex:indexPath.row];
   
    
    
    
    
    
    
    
    
    
    
    
    
    //Patient Age Calculations
    
    
    
  
    

    
    
    
 /*  NSString *pAge = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"patientAge"]];
    NSLog(@"------------>Patient List<-----------%@",[tmpDict objectForKey:@"patientAge"]);
    if (![pAge isEqualToString:@"<null>"])
    {
        NSLog(@"Found Values");
        if (pAge.length!=0)
        {
            
            if(pAge.length<=3)
            {
                _str_LocalAgeStore = [NSString stringWithFormat:@"%@ %@",[tmpDict objectForKey:@"gender"],pAge];
                cell.maleAge.text = [NSString stringWithFormat:@"%@ %@",[tmpDict objectForKey:@"gender"],pAge];
            }
            else
            {
                NSArray *arrAge = [pAge componentsSeparatedByString:@"Y"];
                
                if(arrAge.count!=0)
                {
                    NSString *strYear = [NSString stringWithFormat:@"%@",arrAge[0]];
                    NSArray *arrYear = [strYear componentsSeparatedByString:@"M"];
                    NSString *finalAges;
                    if (arrYear.count!=0)
                    {
                        finalAges = [NSString stringWithFormat:@"%@",arrYear[1]];// Before Upload App Change to arrYear[1]
                    }
                    NSLog(@"AgeValues:%@",finalAges);
                    _str_LocalAgeStore = [NSString stringWithFormat:@"%@ %@",[tmpDict objectForKey:@"gender"],finalAges];
                    cell.maleAge.text = [NSString stringWithFormat:@"%@ %@",[tmpDict objectForKey:@"gender"],finalAges];
                }
                else
                {
                    _str_LocalAgeStore = [NSString stringWithFormat:@"%@ %@",[tmpDict objectForKey:@"gender"],pAge];
                    cell.maleAge.text = [NSString stringWithFormat:@"%@ %@",[tmpDict objectForKey:@"gender"],pAge];
                }
            }
        }
        else
        {
            _str_LocalAgeStore = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"gender"]];
            cell.maleAge.text = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"gender"]];
            
        }
        
        
        
        
    }
    else
    {
        NSLog(@"Table Data NIL");
        // patientAge 1D8M66Y
        NSString *strDobValue = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"dateOfBirth"]];
        if (![strDobValue isEqualToString:@"<null>"])
        {
            _str_LocalAgeStore = [NSString stringWithFormat:@"%@ %ld",[tmpDict objectForKey:@"gender"],(long)[self ComputeYearMonth:[tmpDict objectForKey:@"dateOfBirth"]]];
            cell.maleAge.text = [NSString stringWithFormat:@"%@ %ld",[tmpDict objectForKey:@"gender"],(long)[self ComputeYearMonth:[tmpDict objectForKey:@"dateOfBirth"]]];
        }
        else
        {
            _str_LocalAgeStore = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"gender"]];
            cell.maleAge.text = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"gender"]];
        }
    }
    
    cell.maleAge.text = [NSString stringWithFormat:@"Patient Id: %@",[tmpDict objectForKey:@"patientId"]];
    NSString *strGenderChecking = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"gender"]];
    if ([strGenderChecking isEqualToString:@"Male"])
    {
        cell.genderImage.image = [UIImage imageNamed:@"male.png"];
    }
    else if([strGenderChecking isEqualToString:@"female"])
    {
        cell.genderImage.image = [UIImage imageNamed:@"Female.png"];
    }
    else{
        cell.genderImage.image=[UIImage imageNamed:@"ic_transgender.png"];
        
    }
    
        cell.dateAndTime.text = [self getDateFromUnixFormat:[tmpDict objectForKey:@"createdDate"]];*/
   
 return cell;
  
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
-(NSInteger) ComputeYearMonth :(NSString *)strDOb
{
    
    @try {
        
        NSLog(@"DOB------>:%@",strDOb);
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *DateOfBirth=[format dateFromString:strDOb];
        NSDate *currentTime = [NSDate date];
        
        NSLog(@"DateOfBirth======%@",DateOfBirth);
        
        NSInteger years = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit
                                                           fromDate:DateOfBirth
                                                             toDate:currentTime options:0]year];
        
        NSInteger months = [[[NSCalendar currentCalendar] components:NSMonthCalendarUnit
                                                            fromDate:DateOfBirth
                                                              toDate:currentTime options:0]month];
        NSLog(@"Number of years: %ld",(long)years);
        NSLog(@"Number of Months: %ld,",(long)months);
        
        return years;
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception Values Checking %@",[exception description]);
        
    }
    @finally
    {
        NSLog(@"Finally Exception");
    }
    
    // End of Method
}


-(void)hideTableView
{
    //  _patientList.hidden=YES;
    _tableview.hidden=YES;
    _tables.hidden=YES;
    _patientList.hidden=YES;

    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(20,300,200, 20)];
    label.text = @"No new Patient To Display..!";
    label.textAlignment=UITextAlignmentCenter;
    label.font =[UIFont fontWithName:@"Helvetica Neue LT Pro-Medium" size:15];
    label.textColor =[UIColor lightGrayColor];
    [self.view addSubview:label];
}
-(void)materialDesign
{
    _tables.layer.shadowOffset = CGSizeMake(0,1);
    _tables.layer.shadowRadius = 3;
    _tables.layer.shadowOpacity = 0.5;
}

@end
