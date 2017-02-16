//
//  CellIdTableViewCell.h
//  immi
//
//  Created by Ravi on 30/11/16.
//  Copyright © 2016 ABI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellIdTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *patientImage;
@property (weak, nonatomic) IBOutlet UILabel *pListId;
@property (weak, nonatomic) IBOutlet UILabel *pLisDateTime;
@property (weak, nonatomic) IBOutlet UILabel *pListMale;
@property (weak, nonatomic) IBOutlet UILabel *patientType;

@end
