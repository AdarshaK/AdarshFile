//
//  RecentPatientTableViewCell.h
//  immi
//
//  Created by Ravi on 30/11/16.
//  Copyright © 2016 ABI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentPatientTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *patientId;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTime;
@property (weak, nonatomic) IBOutlet UILabel *maleAge;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UILabel *patientType;

@end
