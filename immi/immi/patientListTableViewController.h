//
//  patientListTableViewController.h
//  immi
//
//  Created by Ravi on 30/11/16.
//  Copyright © 2016 ABI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface patientListTableViewController : UITableViewController
{
    NSArray *patientList;
}
@property(nonatomic,strong)NSMutableArray *reciveData;
@property(nonatomic,strong)NSDictionary *fetchData;
@end
