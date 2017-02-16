//
//  RegisterViewController.m
//  immi
//
//  Created by Ravi on 06/12/16.
//  Copyright © 2016 ABI. All rights reserved.
//

#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "IMMIComplaints.h"
#import "TNResizableTextView.h"
#import "NSString+_emailValidation_.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIView+Toast.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
@interface RegisterViewController ()
{
    NSData *pngData;
    NSData *syncResData;
    NSMutableURLRequest *request;
    UIActivityIndicatorView *indicator;
    NSString *localFilePath;
    NSDictionary *patientId;
}

@end

@implementation RegisterViewController
@synthesize patientName,genderName,dateofBirth,Age,ContactNumber,SymptomsView,SymptomsTexView,addSymptoms,PatientView,ECGFile,ECGFileView,iMageView,GenderView,dateOFBirthView,AgeView,contactNoView,symptomsLabel,rScrollV;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    //removing extra content in the table view
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //Removing name of the bar button
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem]setBackBarButtonItem:newButton];
    //Adding delegates to textfields
    patientName.delegate=self;
    Age.delegate=self;
    ContactNumber.delegate=self;
    SymptomsTexView.delegate=self;
    //Showing keyboard when textField is tapped.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
   //Checking content in the symptoms
   NSLog(@"This is the complaint box %@",complaints.result);
    //campName = [NSArray arrayWithObjects:@{email:@"hh@gmail.com"},@{},@{}, nil];
   
   
    NSLog(@"The string is %@",_regist);
    NSLog(@"camp List from camp:");
    [table reloadData];
    //Calling methods.
    [self CustomViews];
    [self customUIView];
    [self gesture];
   //Checking internet connection
    if (![self internetServiceAvailable])
    {
        UIAlertView *errorAle = [[UIAlertView alloc]initWithTitle:@"No Internet" message:@"Please Turn on Cellular data or wifi for this app in settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAle show];
        
    }
      
    UIAlertController *alerts =[UIAlertController alertControllerWithTitle:@"Select Registration Type" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Imminent" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 NSString *str;
                                 str = @"imminent";
                                 [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"imminent"];
                             }];
    SymptomsView.hidden=NO;
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Routine" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                              {
                                  
                                  
                                  [self layoutSubviews];
                              }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Camp" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                              {
                                  NSString *str;
                                  str = @"camp";
                                  [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"camp"];
                                  addSymptoms.hidden=YES;
                                  
                                  _label.text =@"camp name";
                                  symptomsLabel.text = @"Camp Name";
                                  _label.textColor = [UIColor lightGrayColor];
                                  campB = [[UIButton alloc]initWithFrame:CGRectMake(SymptomsView.frame.origin.x, _label.frame.origin.y+20, 259.0/2.5, 20)];
                                  [campB.titleLabel setFont:[UIFont systemFontOfSize:13]];
                                  [campB setTitle:@"Camp Name" forState:UIControlStateNormal];
                                  [campB setTitleColor:[UIColor colorWithRed:0.0 green:0.40 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                                  [campB addTarget:self action:@selector(setCamptitle:) forControlEvents:UIControlEventTouchUpInside];
                                  [SymptomsView addSubview:campB];
                                  [campB setTag:3];
                                  [self overLapping:campB];
                                  [self get_campDetail];
                              }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"<\t\t\t\t\t\t\t\t" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                              
                              {
                                  
                                  
                                  [self.navigationController popViewControllerAnimated:YES];
                                  
                              }];
    
    [alerts addAction:action];
    
    [alerts addAction:action2 ];
    [alerts addAction:action3];
    [alerts addAction:action4];
    
    [self presentViewController:alerts animated:YES completion:nil];

    
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{}


-(BOOL)internetServiceAvailable
{return [[Reachability reachabilityForInternetConnection]currentReachabilityStatus];}


//unwind seguae from symptoms List
- (IBAction)unwindFromModalViewController:(UIStoryboardSegue *)segue
{if([segue.identifier isEqual:@"receive"])
    {complaints  = (IMMIComplaints *)segue.sourceViewController;
        _label.text = complaints.result;
        _label.textColor = [UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:136.0/255.0 alpha:1];
        _label.minimumFontSize = 15;
    }

}
-(void)get_campDetail
{
    
    NSString *strEmailAddress = [[NSUserDefaults standardUserDefaults]valueForKey:@"Hemail"];
    NSLog(@"------>%@",strEmailAddress);
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.7.150:8080/IMMICloud/referral/campsQueryUrlApp"]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.7.150:8080/IMMICloud/referral/campsQueryUrlApp"]];
        // Specify that it will be a POST request
        request.HTTPMethod = @"POST";
        // This is how we set header fields
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        // Convert your data and set your request's HTTPBody property
        // int a,b;
        // a=b=0;
        //  NSString *stringData = [NSString stringWithFormat:@"{\"username\":\"%@\",\"itemsPerPage\":\"%@\",\"pageNumber\":\"%@\"}",strEmailAddress,[NSNumber numberWithInteger:b],[NSNumber numberWithInteger:a]];
        NSString *stringData = [NSString stringWithFormat:@"{\"userName\":\"%@\"}\"",strEmailAddress];
        //[table reloadData];
        //  NSDictionary *dict = @{@"username":@"",@"itemsPerPage":@0,@"pageNumber":@0 };
        
        NSLog(@"%@",stringData);
        NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = requestBodyData;
        NSData *strResponseData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self getCamp_ListProgress:strResponseData];
            
        });
    });
    
}
-(void)getCamp_ListProgress:(NSData *)responsData
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
                
                //[self stopPreloader];
                
                NSArray *responseArray = [jsonObjects valueForKey:@"list"];
                [[NSUserDefaults standardUserDefaults]setObject:responseArray forKey:@"list"];
                NSLog(@"Response:%@", responseArray);
                [self shouldPerformSegueWithIdentifier:@"register" sender:nil];
                if(responseArray.count!=0)
                {
                    [[NSUserDefaults standardUserDefaults]setObject:@"campName" forKey:[jsonObjects valueForKey:@"campName"]];
                    [[NSUserDefaults standardUserDefaults]setObject:@"campId" forKey:[jsonObjects valueForKey:@"campId"]];
                    [self shouldPerformSegueWithIdentifier:@"register" sender:nil];
                }
                
            }
        }
    }
    @catch(NSException *exception) {
        
        
        NSLog(@"Error Value :%@",[exception description]);
        
        
    }
    @finally
    {
        NSLog(@"Reached");
    }
}

-(void)viewDismissBack
{
    [self performSegueWithIdentifier:@"backtoMain" sender:self];
}

-(void)funcPatientTypeHide{
    
    //_viwPatientTypes.hidden = YES;
    CATransition *transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.duration = 1.0f;
    transition.type = @"cube";
    transition.subtype = @"fromBottom";
    //  [UIView setAnimationTransition:(int)transition forView:_viwPatientTypes  cache:NO];
    [UIView setAnimationDuration:1.0f];
    //   [[_viwPatientTypes layer] addAnimation:transition forKey:nil];
    [UIView commitAnimations];
    
}


/*


//unwindseguae
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//Custom view's
-(void)CustomViews
{
    patientName.clipsToBounds= YES;
   player = [CALayer layer];
    player.borderColor = [[UIColor lightGrayColor] CGColor];
    player.borderWidth = 2;
    player.frame= CGRectMake(0,22, CGRectGetWidth(patientName.frame), CGRectGetHeight(patientName.frame)+2);
    [patientName.layer addSublayer:player];

   _patientLabel.text = @"Patient Name*";
    
    
    _genderB.clipsToBounds =YES;
    glayer = [CALayer layer];
    glayer.borderColor = [[UIColor lightGrayColor] CGColor];
    glayer.borderWidth = 2;
    glayer.frame= CGRectMake(0,22, CGRectGetWidth(_genderB.frame), CGRectGetHeight(_genderB.frame)+2);
    [_genderB.layer addSublayer:glayer];
    
    
    _dateOfB.clipsToBounds =YES;
    dlayer = [CALayer layer];
    dlayer.borderColor = [[UIColor lightGrayColor] CGColor];
    dlayer.borderWidth = 2;
    dlayer.frame= CGRectMake(0,22, CGRectGetWidth(_dateOfB.frame), CGRectGetHeight(_dateOfB.frame)+2);
    [_dateOfB.layer addSublayer:dlayer];
    
    
    
    Age.clipsToBounds= YES;
  alayer = [CALayer layer];
    alayer.borderColor = [[UIColor lightGrayColor] CGColor];
    alayer.borderWidth = 2;
    alayer.frame= CGRectMake(0,22, CGRectGetWidth(Age.frame), CGRectGetHeight(Age.frame)+2);
    [Age.layer addSublayer:alayer];
    
   ContactNumber.clipsToBounds= YES;
    clayer = [CALayer layer];
    clayer.borderColor = [[UIColor lightGrayColor] CGColor];
    clayer.borderWidth = 2;
    clayer.frame= CGRectMake(0,22, CGRectGetWidth(ContactNumber.frame), CGRectGetHeight(ContactNumber.frame)+2);
    [ContactNumber.layer addSublayer:clayer];
    

   symptomsLabel.clipsToBounds=YES;
    blayer = [CALayer layer];
    blayer.borderColor = [[UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:136.0/255.0 alpha:1] CGColor];
    blayer.borderWidth= 2;
    blayer.frame= CGRectMake(0,15, CGRectGetWidth(symptomsLabel.frame), CGRectGetHeight(symptomsLabel.frame)+2);
    [symptomsLabel.layer addSublayer:blayer];
    
    
    _ECGLabel.clipsToBounds =YES;
    elayer = [CALayer layer];
    elayer.borderColor =[[UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:136.0/255.0 alpha:1] CGColor];
    elayer.borderWidth = 2;
    elayer.frame= CGRectMake(0,14, CGRectGetWidth(_ECGLabel.frame), CGRectGetHeight(_ECGLabel.frame)+2);
    [_ECGLabel.layer addSublayer:elayer];
    
 }
- (IBAction)genderClick:(id)sender {
   // [self layoutSubviews];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Male"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           _genderB.text=@"Male";
                                                            [_genderB setTextColor:[UIColor blackColor]];
                                                          }];
    [alert addAction:firstAction];
    
    UIAlertAction *second = [UIAlertAction actionWithTitle:@"Female"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              
                                                           _genderB.text=@"Female";
                                                            [_genderB setTextColor:[UIColor blackColor]];
                                                          }];
    [alert addAction:second];
    UIAlertAction *third = [UIAlertAction actionWithTitle:@"Other"
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                         
                                                         _genderB.text=@"Other";
                                                         [_genderB setTextColor:[UIColor blackColor]];
                                                     }];
    CGFloat margin = 8.0F;
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(margin,margin,40.0F ,40.0F)];
    image.image=[UIImage imageNamed:@"Alertlogo.png"];
    [alert.view addSubview:image];
    
    
    
    
    [alert addAction:third];
    [self presentViewController:alert animated:YES completion:nil];

 
       [_genderClick setTag:1];
    [self overLapping:_genderClick];
   
    }
-(void)DatePicker
{
}

-(void)CampType
{
}
-(IBAction) buttonClicked1: (id) sender
{
    SymptomsView.hidden=NO;
    viewblack.hidden=YES;
   
}
-(IBAction)buttonClicked2:(id)sender
{
  //  SymptomsView.hidden=YES;
   // SymptomsView.frame= ECGFileView.frame;
    viewblack.hidden=YES;
    [self layoutSubviews];
}

    -(IBAction)buttonClicked3:(id)sender
{
    addSymptoms.hidden=YES;
    viewblack.hidden=YES;
    _label.text =@"camp name";
symptomsLabel.text = @"Camp Name";
    _label.textColor = [UIColor lightGrayColor];
    campB = [[UIButton alloc]initWithFrame:CGRectMake(SymptomsView.frame.origin.x, _label.frame.origin.y+20, 259.0/2.5, 20)];
    [campB.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [campB setTitle:@"Camp Name" forState:UIControlStateNormal];
    [campB setTitleColor:[UIColor colorWithRed:0.0 green:0.40 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [campB addTarget:self action:@selector(setCamptitle:) forControlEvents:UIControlEventTouchUpInside];
     [SymptomsView addSubview:campB];
   [campB setTag:3];
    [self overLapping:campB];
}
-(void)setCamptitle:(id)sender
{
    campView = [[UIView alloc]initWithFrame:CGRectMake(SymptomsView.frame.origin.x+27, SymptomsView.frame.origin.y+campB.frame.origin.y+52, 259.0/2.0, 75)];
    campView.backgroundColor = [UIColor yellowColor];
    campView.layer.shadowOffset=CGSizeMake(2, 2);
    campView.layer.shadowRadius=10;
    campView.layer.shadowOpacity=0.7f;
    [self.view addSubview:campView];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, campView.frame.size.width,campView.frame.size.height) style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    table.scrollEnabled=YES;
    table.backgroundColor =[UIColor whiteColor];
    
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [campView addSubview:table];
  
}
-(IBAction)addSymptomS:(id)sender
{
    addSymptomS.enabled=YES;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return campName.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString  *cellIdentifier=  @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!(cell))
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    }
    if(campName.count!=0)
    {
    dict = [campName objectAtIndex:indexPath.row];
    }
    else{
        campView.hidden=YES;
        UIAlertView *errorAle = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"No camp to show" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAle show];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"list"];
    }
    
    
    cell.textLabel.text=[dict objectForKey:@"campName"];
    
    cell.layer.shadowOffset=CGSizeMake(0, 1);
    cell.layer.shadowRadius=0.5;
    cell.layer.shadowOpacity=0.5f;
   // cell.layer.shadowColor= [[UIColor greenColor]CGColor];
    CGRect cellSize = cell.frame;
    cellSize.size.width = table.frame.size.width;
    cell.frame=cellSize;
    cell.textLabel.textAlignment= UITextAlignmentCenter;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 30;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dict = [campName objectAtIndex:indexPath.row];

   
  _label.text  = [dict objectForKey:@"campName"];
    _label.textColor= [UIColor blackColor];
    campView.hidden = YES;

}


-(void)ButtonClickBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)layoutSubviews{
    CGFloat currentY = 238;//some initial value
    CGFloat labelX = 25;//some value
    SymptomsView.frame = CGRectMake(labelX,currentY,CGRectGetWidth(SymptomsView.bounds),CGRectGetHeight(SymptomsView.bounds));
    
    if(!SymptomsView.hidden){
        currentY += CGRectGetHeight(SymptomsView.bounds);
    NSLog(@"current Y = %f",currentY);
    }
    NSLog(@"current Y = %f",currentY);
        ECGFileView.frame = CGRectMake(labelX,currentY,CGRectGetWidth(ECGFileView.bounds),CGRectGetHeight(ECGFileView.bounds));
   
        if(!ECGFileView.hidden){
        currentY = CGRectGetHeight(ECGFileView.bounds);
   NSLog(@"current Y = %f",currentY);
        }
    
    NSLog(@"current Y = %f",currentY);
    SymptomsView.hidden= YES;
    

    //continue with the other views
}
-(IBAction)buttonClickedM:(id)sender
{
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setButtonEnabled:) userInfo:nil repeats:NO];
    _genderB.textColor=[UIColor blackColor];
    _genderB.text = btnM.titleLabel.text;
   
}
-(IBAction)buttonClickedF:(id)sender
{
    genderV.hidden=YES;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setButtonEnabled:) userInfo:nil repeats:NO];
    _genderB.text =  btnF.titleLabel.text;
   _genderB.textColor=[UIColor blackColor];
 }
-(IBAction)buttonClickedO:(id)sender
{
    
    genderV.hidden=YES;
   
  //  double delayInSeconds = 2.0;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setButtonEnabled:) userInfo:nil repeats:NO];
  _genderB.text = btnO.titleLabel.text;
     _genderB.textColor=[UIColor blackColor];
}
-(void)setButtonEnabled:(UIGestureRecognizer *) sender
{
    genderV.hidden=YES;
    _genderClick.enabled=YES;
    
}
- (IBAction)dateOFBirth:(id)sender {
   
    UIAlertController *alerts =[UIAlertController alertControllerWithTitle:@"Do you know Date of Birth?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 [self buttonClickedY:sender ];
                                 
                             }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                             {
                                
                                 
                             }];
    [alerts addAction:action];
    [alerts addAction:action2];

    [self presentViewController:alerts animated:YES completion:nil];
    
    
     [_dateOfBirth setTag:2];
    [self overLapping:_dateOfBirth];
}
-(IBAction)buttonClickedY:(id)sender
{
    UIAlertController *alertDate = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    CGFloat margin=8.0F;
   //  dataPicker =[[UIView alloc ]initWithFrame:CGRectMake(margin,margin,alertDate.view.bounds.size.width-margin*4.0F,285.0F)];
    dateview.backgroundColor=[UIColor greenColor];
  dataPicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(margin,margin,alertDate.view.bounds.size.width-margin*4.0F, 285.0F)];
    dataPicker.datePickerMode =UIDatePickerModeDate;
    [dataPicker addTarget:self action:@selector(Result:) forControlEvents:UIControlEventValueChanged];
    dataPicker.backgroundColor =[UIColor clearColor];
   
   
    [alertDate.view addSubview:dataPicker];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Done"
                                                          style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                              
                                                              
                                                          }];
    
    
    [alertDate addAction:firstAction];
    [self presentViewController:alertDate animated:YES completion:nil];
    
  
}

- (void) buttonClickedD:(UIGestureRecognizer *) sender{
   
    
    _dateOfBirth.enabled=YES;
    dateOFBirth.hidden=YES;
    dateview.hidden=YES;
}
-(void)buttonCliC:(UIGestureRecognizer *)sender
{
    campView.hidden=YES;
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    campView.hidden=YES;
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [self.rScrollV endEditing:YES];
   
}
-(IBAction)buttonClickedN:(id)sender
{
    dateOFBirth.hidden=YES;
    _dateOfBirth.enabled = YES;
}
- (IBAction)AddSymptoms:(id)sender {
    viewblack.hidden=YES;
}
- (IBAction)registerPatient:(id)sender {
   
    //Animation
    UIImage *Alertimage =[UIImage imageNamed:@"Alertlogo.png"];
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [animate setToValue:[NSNumber numberWithFloat:0.0f]];
    [animate setFromValue:[NSNumber numberWithDouble:M_PI/16]];
    [animate setDuration:0.1];
    [animate setRepeatCount:NSUIntegerMax];
    [animate setAutoreverses:YES];
    if (![self internetServiceAvailable])
    {
        UIAlertView *errorAle = [[UIAlertView alloc]initWithTitle:@"No Internet" message:@"Please Turn on Cellular data or wifi for this app in settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAle show];
        
    }

    if([patientName.text isEqual:@""])
    {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        imgView.contentMode=UIViewContentModeTop;
        [imgView setImage:Alertimage];
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Enter patient Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        
    
    }
  else if([_genderB.text isEqual:@"Gender"])
    {
       [self upload];
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please Enter Gender Type" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlert show];
        //Adding images to the Alert view
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(160.5, 27, 50, 50)];
        imgView.contentMode=UIViewContentModeCenter;
        [imgView setImage:Alertimage];
        [[imgView layer] addAnimation:animate forKey:@"iconShake"];
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

        
    }
       else if([Age.text  isEqual: @""])
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please Enter Age" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlert show];
        //Adding images to the Alert view
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(160.5, 27, 50, 50)];
        imgView.contentMode=UIViewContentModeCenter;
        [imgView setImage:Alertimage];
        [[imgView layer] addAnimation:animate forKey:@"iconShake"];
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

    }
    else if([_label.text  isEqual:@""] || [_label.text  isEqual:@"camp name"])
    {
        UIAlertView *errorAlert;
        if([symptomsLabel.text  isEqual: @"Symptoms*"])
            
        {
        errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please Add Symptoms" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [errorAlert show];
        }
        else{
            errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please Select Camp Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [errorAlert show];
        }
        //Adding images to the Alert view
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(160.5, 27, 50, 50)];
        imgView.contentMode=UIViewContentModeCenter;
        [imgView setImage:Alertimage];
        [[imgView layer] addAnimation:animate forKey:@"iconShake"];
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

     // [errorAlert show];
    }
    else if(iMageView.image == nil)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please Select ECG File" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlert show];
        //Adding images to the Alert view
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(160.5, 27, 50, 50)];
        imgView.contentMode=UIViewContentModeCenter;
        [imgView setImage:Alertimage];
        [[imgView layer] addAnimation:animate forKey:@"iconShake"];
        [[errorAlert layer] addAnimation:animate forKey:@"iconShake"];
        //ios7.0 and above version
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [errorAlert setValue:imgView forKey:@"accessoryView"];
        }else{
            
            [errorAlert addSubview:imgView];
        }
        //Changing the tint color of the text
        [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertView class]]] setTintColor:[UIColor greenColor]];
        
        [errorAlert show];
        AudioServicesPlaySystemSound(1352) ;

    }
    else{
        [self upload];
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Sucess" message:@"Registration Sucessful!" preferredStyle:UIAlertControllerStyleAlert];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(160.5, 27, 50, 50)];
        imgView.contentMode=UIViewContentModeCenter;
        [imgView setImage:Alertimage];
        [[imgView layer] addAnimation:animate forKey:@"iconShake"];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                                                                                                 {
                                                                               
                                                                                    [self.navigationController popViewControllerAnimated:YES];                             }];
        [alert addAction:action];
        //Changing the tint color of the text
        
        [self presentViewController:alert animated:YES completion:nil];
        
        AudioServicesPlaySystemSound(1352) ;

        
        
    }
}
-(void)send_Request {
  //  NSDate * dateSelected = ((UIDatePicker *) sender).date;
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString    *strTime = [objDateformat stringFromDate:[NSDate date]];
    NSString    *strUTCTime = [self GetUTCDateTimeFromLocalTime:strTime];//You can pass your date but be carefull about your date format of NSDateFormatter.
    NSDate *objUTCDate  = [objDateformat dateFromString:strUTCTime];
    long long milliseconds = (long long)([objUTCDate timeIntervalSince1970] * 1000.0);
    NSString *strTimeStamp = [NSString stringWithFormat:@"%lld",milliseconds];
    NSLog(@"The Timestamp is = %lld",milliseconds);
   NSString *strEmailAddress = [[NSUserDefaults standardUserDefaults]valueForKey:@"Hemail"];
    dict=@{@"username":strEmailAddress,
                          @"firstName":patientName.text,
                          @"lastName":@"",
                          @"gender":_genderB.text,
                          @"dob":[NSNumber numberWithLongLong:milliseconds],
                          @"contactNumber":ContactNumber.text,
                          @"emergencyCOntactNumber":@"",
                          @"patHistory":[NSNull null]};
    NSData *data =[NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil ];
    NSLog(@"Dictonary content %@",dict);
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.7.150:8080/IMMICloud/patient/queryPatientsApp/"]];
    request = [[NSMutableURLRequest alloc]init];
    NSURL *url = [NSURL URLWithString:@"http://192.168.7.150:8080/IMMICloud/patient/addPatientApp"];
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
    NSLog(@"Dict:%@",dict);
  NSDictionary  *patientId=[str1 valueForKey:@"immiPatinetId"];
    NSLog(@"patientId %@",patientId);
    
}
- (void) Result : (id) sender
{
    NSDate * dateSelected = ((UIDatePicker *) sender).date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    _dateOfB.textColor = [UIColor blackColor];
    self.dateOfB.text = [formatter stringFromDate:dateSelected];
}

/*- (void)GetCurrentTimeStamp:(id)sender
{
     NSDate * dateSelected = ((UIDatePicker *) sender).date;
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString    *strTime = [objDateformat stringFromDate:dateSelected];
    NSString    *strUTCTime = [self GetUTCDateTimeFromLocalTime:strTime];//You can pass your date but be carefull about your date format of NSDateFormatter.
    NSDate *objUTCDate  = [objDateformat dateFromString:strUTCTime];
    long long milliseconds = (long long)([objUTCDate timeIntervalSince1970] * 1000.0);
    
    NSString *strTimeStamp = [NSString stringWithFormat:@"%lld",milliseconds];
    NSLog(@"The Timestamp is = %lld",milliseconds
          );
}
 */

- (NSString *) GetUTCDateTimeFromLocalTime:(NSString *)IN_strLocalTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate  *objDate    = [dateFormatter dateFromString:IN_strLocalTime];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *strDateTime   = [dateFormatter stringFromDate:objDate];
    return strDateTime;
}
- (void) upload {
    //   [request setURL:[NSURL URLWithString:urlString]];
    // [request setHTTPMethod:@"POST"];
    NSDictionary  *dictt=@{@"studyUID":[NSNull null],
                          @"seriesUID":[NSNull null],
                          @"patientId":@"000-000-4114" };
    NSString *boundary = [self generateBoundaryString];
    
    NSString *path=localFilePath;
    // configure the request
    NSURL *url = [NSURL URLWithString:@"http://192.168.7.150:8080/IMMICloud/file/storeImageApp"];
    request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // set content type
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // create body
    
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:dictt paths:@[path] fieldName:@"file"];
    [request setHTTPBody:httpBody];
    
    NSURLResponse * response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *str1 =[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"List :%@",str1);
    /*if(pngData!=NULL)
     {
     
     
     
     NSData *data =[NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil ];
     
     // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.7.150:8080/IMMICloud/patient/queryPatientsApp/"]];
     request = [[NSMutableURLRequest alloc]init];
     
     [request setURL:url];
     [request setHTTPMethod:@"POST"];
     
     NSString *contentType = [NSString stringWithFormat:@"multipart/form-data"];
     [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     //  [request addRequestHeader:@"User-Agent" value:@"iOS"];
     [request setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
     
     [request setHTTPBody:data];
     
     NSURLResponse * response;
     NSError *error;
     NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
     NSString *str1 =[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
     NSLog(@"List :%@",str1);
     }*/
    
}
- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    
    for (NSString *path in paths) {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}
- (NSString *)mimeTypeForPath:(NSString *)path
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}


- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    
    // if supporting iOS versions prior to 6.0, you do something like:
    //
    // // generate boundary string
    // //
    // adapted from http://developer.apple.com/library/ios/#samplecode/SimpleURLConnections
    //
    // CFUUIDRef  uuid;
    // NSString  *uuidStr;
    //
    // uuid = CFUUIDCreate(NULL);
    // assert(uuid != NULL);
    //
    // uuidStr = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    // assert(uuidStr != NULL);
    //
    // CFRelease(uuid);
    //
    // return uuidStr;
}

- (IBAction)ECGFile:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Camera"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              
                                                              if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                                  
                                                                  UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                                        message:@"Device has no camera"
                                                                                                                       delegate:nil
                                                                                                              cancelButtonTitle:@"OK"
                                                                                                              otherButtonTitles: nil];
                                                                  
                                                                  [myAlertView show];
                                                              }
                                                              else{
                                                                  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                                  picker.delegate = self;
                                                                  picker.allowsEditing = YES;
                                                                  picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                  
                                                                  [self presentViewController:picker animated:YES completion:NULL];
                                                                  
                                                                  
                                                              }
                                                              NSLog(@"You pressed button one");
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Gallery"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
                                                               pickerController.delegate = self;
                                                               
                                                               
                                                               
                                                               pickerController.allowsEditing = YES;
                                                               pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                               
                                                               [self presentViewController:pickerController animated:YES completion:NULL];
                                                               
                                                               
                                                               
                                                               
                                                               NSLog(@"You pressed button two");
                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    CGFloat margin = 8.0F;
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(margin,margin,40.0F ,40.0F)];
    image.image=[UIImage imageNamed:@"Alertlogo.png"];
    [alert.view addSubview:image];
    [self presentViewController:alert animated:YES completion:nil];
    [ECGFile setTag:4];
   [self overLapping:ECGFile];
}





-(IBAction)buttonClickedC:(id)sender
{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setButtonEnabledC:) userInfo:nil repeats:NO];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    else{
       UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
   
    [self presentViewController:picker animated:YES completion:NULL];
    }
   }
-(IBAction)buttonClickedG:(id)sender
{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setButtonEnabledC:) userInfo:nil repeats:NO];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   
    [self presentViewController:picker animated:YES completion:NULL];
}
-(void)setButtonEnabledC:(UIGestureRecognizer *) sender
{
    cameraV.hidden= YES;
    ECGFile.enabled=YES;
    
}
-(void)gesture
{
    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setButtonEnabled:)];
    gestureRecognizer.delegate = self;
    [rScrollV addGestureRecognizer:gestureRecognizer];
    
    gestureDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClickedD:)];
    gestureDate.delegate = self;
    [rScrollV addGestureRecognizer:gestureDate];
    
    gestureCam = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setButtonEnabledC:)];
    gestureCam.delegate = self;
    [rScrollV addGestureRecognizer:gestureCam];
   
    gestureCamp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonCliC:)];
    gestureCamp.delegate=self;
    [rScrollV addGestureRecognizer:gestureCamp];
    
    /*gestureKey=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardWillBeHidden:) ];
    gestureKey.delegate=self;
    [rScrollV addGestureRecognizer:gestureKey];*/
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated:YES];
    iMageView.image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    pngData = UIImagePNGRepresentation(iMageView.image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    localFilePath = [documentsDirectory stringByAppendingPathComponent:@"file.png"];
    [pngData writeToFile:localFilePath atomically:YES];
    NSLog(@"localFilePath.%@",localFilePath);
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)customUIView
{
    
    SymptomsView.layer.shadowOffset=CGSizeMake(2, 2);
    SymptomsView.layer.shadowRadius=5;
    SymptomsView.layer.shadowOpacity=0.5;
    
    PatientView.layer.shadowOffset =CGSizeMake(2, 2);
    PatientView.layer.shadowRadius=5;
    PatientView.layer.shadowOpacity=0.5;
    
    ECGFileView.layer.shadowOffset=CGSizeMake(2, 2);
    ECGFileView.layer.shadowRadius=5;
    ECGFileView.layer.shadowOpacity=0.5;
   
    GenderView.layer.shadowOffset=CGSizeMake(2, 2);
    GenderView.layer.shadowRadius=5;
    GenderView.layer.shadowOpacity=0.5;
    
    dateOFBirthView.layer.shadowOffset=CGSizeMake(2, 2);
    dateOFBirthView.layer.shadowRadius=5;
    dateOFBirthView.layer.shadowOpacity=0.5;
  
    AgeView.layer.shadowOffset =CGSizeMake(2, 2);
    AgeView.layer.shadowRadius=5;
    AgeView.layer.shadowOpacity=0.5;
    
    contactNoView.layer.shadowOffset=CGSizeMake(2, 2);
    contactNoView.layer.shadowRadius=5;
    contactNoView.layer.shadowOpacity=0.5;
    
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.patientName)
    {
        
        //[self.GenderView becomeFirstResponder];
    [textField resignFirstResponder];
    }
    else if(textField==self.Age)
    {
        //[self.ContactNumber becomeFirstResponder];
        [textField resignFirstResponder];
    }
    else if(textField==self.ContactNumber)
    {
       // [self.SymptomsTexView becomeFirstResponder];
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    
    
    if(textView==SymptomsTexView)
    {
        [self.ECGFile becomeFirstResponder];
        [textView resignFirstResponder];
    }
    
    

}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
        return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
   
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    /* [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];*/
}
-(void)textView

{
   SymptomsTexView.text = @"This returns the size of the rectangle that fits the given string with the given font. Pass in a size with the desired width and a maximum height, and then you can look at the height returned to fit the text. There is a version that lets you specify line break mode also.This returns the size of the rectangle that fits the given string with the given font. Pass in a size with the desired width and a maximum height, and then you can look at the height returned to fit the text. There is a version that lets you specify line break mode yes.";
    CGRect textFrame =SymptomsTexView.frame;
   textFrame.size.height = SymptomsTexView.contentSize.height;
    SymptomsTexView.frame = textFrame;
    
    
}
- (void)keyboardWillShow:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.0 animations:^
     {
         campView.hidden=YES;
         CGRect newFrame = [rScrollV frame];
         newFrame.origin.y -= 55; // tweak here to adjust the moving position
         [rScrollV setFrame:newFrame];
         
     }completion:^(BOOL finished)
     {
         
     }];
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.25 animations:^
     {
         CGRect newFrame = [rScrollV frame];
         newFrame.origin.y += 55; // tweak here to adjust the moving position
         [rScrollV setFrame:newFrame];
         
     }completion:^(BOOL finished)
     {
         
     }];
    
}
-(void)overLapping:(UIButton *)button

{
    NSLog(@"button tappeld %ld",(long)[button tag]);
    genderV.hidden = button.tag != 1;
    dateOFBirth.hidden = button.tag != 2;
   campView.hidden = button.tag != 3;
       cameraV.hidden = button.tag != 4;

}
/*
 - (void)viewDidLoad {
 
 [super viewDidLoad];
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
 
 }
 
 - (void)keyboardWillShow:(NSNotification*)aNotification {
 [UIView animateWithDuration:0.25 animations:^
 {
 CGRect newFrame = [customView frame];
 newFrame.origin.y -= 50; // tweak here to adjust the moving position
 [customView setFrame:newFrame];
 
 }completion:^(BOOL finished)
 {
 
 }];
 }*/
/*-void setBounds:(CGRect)UIDynamicItemCollisionBoundsType
{
    descriptionHeightConstraint = [NSLayoutConstraint constraintWithItem:SymptomsTexView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:0.f
                                                                 constant:100];}
    
[self]
}
 -(void) setBounds:(CGRect)bounds
 {
 [super setBounds:bounds];
 
 SymptomsTexView.frame = bounds;
 CGSize descriptionSize =SymptomsTexView.contentSize;
 
 [_descriptionHeightConstraint setConstant:descriptionSize.height];
 
 [self layoutIfNeeded];
 }
 */


@end
