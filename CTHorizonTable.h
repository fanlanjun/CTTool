//
//  CTHorizonTable.h
//  Infinitus
//
//  Created by fan frank on 12-6-1.
//  Copyright 2012年 frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTHorizonTable : UITableView
{    
}

@end

@interface CTHorizonTableCell : UITableViewCell
{
}

/**
 * frame.size是cell的宽和高，origin x和y都为0
 * 添加view到cell时使用cell.contentView添加
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

@end
