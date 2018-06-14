//
//  CCityOptionDetailView.m
//  LFOA
//
//  Created by Stenson on 2018/6/11.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOptionDetailView.h"
#import "CCityNotficModel.h"
#import "CCityMainMeetingListModel.h"
@interface CCityOptionDetailView()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * _dataArr;
    CCityDropdownBox _boxStyle;
}
@end


@implementation CCityOptionDetailView

-(id)initWithData:(NSArray *)arr withType:(CCityDropdownBox)showType withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _frameRect = frame;
        _dataArr = arr;
        _boxStyle = showType;
        [self initView];
    }
    return self;
}

-(void)initView
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _frameRect.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
}

#pragma mark - UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (_boxStyle == CCityDropdownBoxDepartment) {
        CCityNewNotficDepartmentModel * model = _dataArr[indexPath.row];
        cell.textLabel.text = model.ORGANIZATIONNAME;
    }else if (_boxStyle == CCityDropdownBoxMeeting){
        CCityNewMeetingTypeModel * model = _dataArr[indexPath.row];
        cell.textLabel.text = model.HYNAME;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject * obj = nil;
    if (_boxStyle == CCityDropdownBoxDepartment) {
        CCityNewNotficDepartmentModel * model = _dataArr[indexPath.row];
        obj = model;
    }else if (_boxStyle == CCityDropdownBoxMeeting){
        CCityNewMeetingTypeModel * model = _dataArr[indexPath.row];
        obj = model;
    }

    if ([self.delegate respondsToSelector:@selector(didSelectOption:)]) {
        [self.delegate didSelectOption:obj];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
