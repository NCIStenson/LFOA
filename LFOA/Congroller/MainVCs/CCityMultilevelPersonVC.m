//
//  CCityMultilevelPersonVC.m
//  LFOA
//
//  Created by Stenson on 2018/6/11.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//
#define kFirstLetterHeight 40.0f
#define kcontentCellHeight 44.0f

#import "CCityMultilevelPersonVC.h"
#import "CCityNotficModel.h"
#import "BEMCheckBox.h"

@interface CCityMultilevelPersonVC ()<UITableViewDelegate,UITableViewDataSource,BEMCheckBoxDelegate>
{
    UITableView * _contentTableView;
}
@end

@implementation CCityMultilevelPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发送给";
    [self initView];
}

-(void)initView{
    
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    [self.view addSubview:_contentTableView];
    if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
        _contentTableView.height = SCREEN_HEIGHT - NAV_HEIGHT - 74.0f;
    } else {
        _contentTableView.height = SCREEN_HEIGHT - NAV_HEIGHT - 50.f;
    }

    UIView * _footerView =[self footerView];
    [self.view addSubview:_footerView];
    _footerView.frame = CGRectMake(0, _contentTableView.bottom, SCREEN_WIDTH, IPHONEX ? 74 : 50);
}

- (UIView*)footerView {
    
    UIView* footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton* writeOpinioBtn =  [self getBottomBtnWithTitle:@"提交" sel:@selector(writeOpinioAction)];
    
    [footerView addSubview:writeOpinioBtn];
    
    [writeOpinioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(footerView).with.offset(5.f);
        make.left.equalTo(footerView).with.offset(10.f);
        make.right.equalTo(footerView).offset(-10.f);
        
        if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
            
            make.bottom.equalTo(footerView).with.offset(-30.f);
        } else {
            
            make.bottom.equalTo(footerView).with.offset(-10.f);
        }
    }];
    return footerView;
}

-(UIButton*)getBottomBtnWithTitle:(NSString*)title sel:(SEL)sel {
    
    UIButton* bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bottomBtn.backgroundColor = CCITY_MAIN_COLOR;
    [bottomBtn setTitle:title forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.clipsToBounds = YES;
    bottomBtn.layer.cornerRadius = 5.f;
    [bottomBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return bottomBtn;
}


-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [_contentTableView reloadData];
}
#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CCityNewNotficPersonModel * model = _dataArr[section];
    if(!model.isOpen){
        return 0;
    }
    return model.orgModelArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CCityNewNotficPersonModel * model = _dataArr[section];
    
    UIView * view = [self getHeaderTitleViewWithModel:model withIndex:section];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)getHeaderTitleViewWithModel:(CCityNewNotficPersonModel*)model withIndex:(NSInteger)index
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kcontentCellHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    BEMCheckBox* checkBox = [[BEMCheckBox alloc]init];
    checkBox.boxType = BEMBoxTypeSquare;
    checkBox.onTintColor = CCITY_MAIN_COLOR;
    checkBox.onCheckColor = CCITY_MAIN_COLOR;
    checkBox.delegate = self;
    checkBox.on = model.isSelected;
    checkBox.tag = 100 + index;
    
    UIButton * personLabel =  [UIButton buttonWithType:UIButtonTypeCustom];
    personLabel.tag = 100 + index;
    [personLabel setTitle:model.text forState:UIControlStateNormal];
    personLabel.titleLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    [personLabel setTitleColor:CCITY_MAIN_FONT_COLOR forState:UIControlStateNormal];
    [personLabel addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:checkBox];
    [view addSubview:personLabel];
    personLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    checkBox.top = 12.f;
    checkBox.left = 30.0f;
    checkBox.size = CGSizeMake(20, 20);
    
    personLabel.top = 5.f;
    personLabel.left = checkBox.right + 10.0f;
    personLabel.size = CGSizeMake(SCREEN_WIDTH - checkBox.left , 34);

    return view;
}

-(UIView *)getOrgTitleViewIndex:(NSIndexPath *)indexPath
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kcontentCellHeight)];
    
    CCityNewNotficPersonModel * model = _dataArr[indexPath.section];
    CCityNewNotficPersonModel * orgModel = model.orgModelArr[indexPath.row];
    
    BEMCheckBox* checkBox = [[BEMCheckBox alloc]init];
    checkBox.boxType = BEMBoxTypeSquare;
    checkBox.delegate = self;
    checkBox.onTintColor = CCITY_MAIN_COLOR;
    checkBox.onCheckColor = CCITY_MAIN_COLOR;
    checkBox.on = orgModel.isSelected;
    checkBox.tag = 500 + indexPath.row;

    UIButton * personLabel =  [UIButton buttonWithType:UIButtonTypeCustom];
    [personLabel setTitle:orgModel.text forState:UIControlStateNormal];
    personLabel.titleLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    [personLabel setTitleColor:CCITY_MAIN_FONT_COLOR forState:UIControlStateNormal];
    [view addSubview:checkBox];
    [view addSubview:personLabel];
    personLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [personLabel addTarget:self action:@selector(orgModelClick:) forControlEvents:UIControlEventTouchUpInside];
    personLabel.tag = indexPath.row + 100;
    
    checkBox.top = 12.f;
    checkBox.left = 50.0f;
    checkBox.size = CGSizeMake(20, 20);
    
    personLabel.top = 5.f;
    personLabel.left = checkBox.right + 10.0f;
    personLabel.size = CGSizeMake(SCREEN_WIDTH - checkBox.left , 34);

    return view;
}

-(UIView *)getPersonalTitleViewWithModel:(CCityNewNotficPersonModel *)model
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,kcontentCellHeight, SCREEN_WIDTH, kcontentCellHeight)];
    view.backgroundColor = MAIN_LINE_COLOR;
    
    BEMCheckBox* checkBox = [[BEMCheckBox alloc]init];
    checkBox.boxType = BEMBoxTypeSquare;
    checkBox.onTintColor = CCITY_MAIN_COLOR;
    checkBox.onCheckColor = CCITY_MAIN_COLOR;
    checkBox.userInteractionEnabled = NO;
    checkBox.on = model.isSelected;
    
    UIImageView * personImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_offical_sendDoc_addPerson_50x50_"]];
    
    UIButton * personLabel =  [UIButton buttonWithType:UIButtonTypeCustom];
    [personLabel setTitle:model.text forState:UIControlStateNormal];
    personLabel.titleLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    [personLabel setTitleColor:CCITY_MAIN_FONT_COLOR forState:UIControlStateNormal];
    [personLabel addTarget:self action:@selector(personalModelClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:checkBox];
    [view addSubview:personImageView];
    [view addSubview:personLabel];
    personLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    checkBox.top = 12.f;
    checkBox.left = 70.0f;
    checkBox.size = CGSizeMake(20, 20);
    
    personImageView.top = 10.f;
    personImageView.left = checkBox.right + 5.0f;
    personImageView.size = CGSizeMake(24, 24);
    
    personLabel.top = personImageView.top;
    personLabel.left = personImageView.right + 5.0f;
    personLabel.size = CGSizeMake(SCREEN_WIDTH - personImageView.left , 24);
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    while (cell.contentView.subviews.lastObject) {
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    
    CCityNewNotficPersonModel * model = _dataArr[indexPath.section];
    CCityNewNotficPersonModel * orgModel =  model.orgModelArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView * view = [self getOrgTitleViewIndex:indexPath];
    [cell.contentView addSubview:view];
    
    if (orgModel.isOpen) {
        
        float marginTop = kcontentCellHeight;
        
        NSArray * arr = model.personalModelFirstLetterArr[indexPath.row];
        for (int i = 0; i < arr.count; i ++) {
            NSDictionary * dic = model.personalModelFormatArr[indexPath.row];
            NSString * keyValue = arr[i];
            NSArray * valuesArr = [dic objectForKey:keyValue];
            
            UILabel * letterLab = [UILabel new];
            letterLab.frame = CGRectMake(0, marginTop, SCREEN_WIDTH, kFirstLetterHeight);
            letterLab.text = [NSString stringWithFormat:@"                 %@",keyValue];
            letterLab.backgroundColor = MAIN_DEEPLINE_COLOR;
            [cell.contentView addSubview:letterLab];
            marginTop += kFirstLetterHeight;
            
            for (int j = 0; j < valuesArr.count  ; j ++) {
                CCityNewNotficPersonModel * personModel = valuesArr[j];
                UIView * view = [self getPersonalTitleViewWithModel:personModel];
                view.top = marginTop ;
                [cell.contentView addSubview:view];
                marginTop += kcontentCellHeight;
                if (j < valuesArr.count - 1) {
                    UIView * lineView = [UIView new];
                    lineView.frame = CGRectMake(0, marginTop - .5, SCREEN_WIDTH, .5);
                    lineView.backgroundColor = MAIN_DEEPLINE_COLOR;
                    [cell.contentView addSubview:lineView];
                }

            }
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCityNewNotficPersonModel * model = _dataArr[indexPath.section];
    CCityNewNotficPersonModel * orgModel =  model.orgModelArr[indexPath.row];

    if (orgModel.isOpen) {
        
        NSArray * personalModelArr =  model.personModelArr[indexPath.row];
        NSArray * personalLetterArr = model.personalModelFormatArr[indexPath.row];
        return (personalModelArr.count + 1) * kcontentCellHeight + personalLetterArr.count * kFirstLetterHeight;
    }

    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 规划局
-(void)headerViewClick:(UIButton *)btn
{
    NSInteger index = btn.tag - 100;
    CCityNewNotficPersonModel * model = _dataArr[index];
    model.isOpen = !model.isOpen;
    [_contentTableView reloadSection:index withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 科室
-(void)orgModelClick:(UIButton *)btn
{
    NSIndexPath * indexpath = [_contentTableView indexPathForCell:(UITableViewCell *)btn.superview.superview.superview];
    
    CCityNewNotficPersonModel * model = _dataArr[indexpath.section];
    CCityNewNotficPersonModel * orgmodel = model.orgModelArr[indexpath.row];
    orgmodel.isOpen = !orgmodel.isOpen;
    [_contentTableView reloadRow:indexpath.row inSection:indexpath.section withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 人员
-(void)personalModelClick:(UIButton *)btn
{

}




-(void)didTapCheckBox:(BEMCheckBox *)checkBox
{
    NSLog(@" -- -- - - -- %d",checkBox.tag);
    UIView * view = checkBox.superview.superview.superview;
    if ([view isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [_contentTableView indexPathForCell:(UITableViewCell *)view];
        CCityNewNotficPersonModel * headerModel =  _dataArr[indexPath.section];
        CCityNewNotficPersonModel * orgmodel = headerModel.orgModelArr[indexPath.row];
        orgmodel.isOpen = !orgmodel.isOpen;
        orgmodel.isSelected = !orgmodel.isSelected;

        NSArray * letterArr = headerModel.personalModelFirstLetterArr[indexPath.row];
        NSDictionary * dic =  headerModel.personalModelFormatArr[indexPath.row];

        for (int i = 0; i < letterArr.count ; i ++) {
            NSString * keyValue = letterArr[i];
            NSMutableArray * arr = dic[keyValue];
            for ( int j = 0; j < arr.count; j ++) {
                CCityNewNotficPersonModel * personalModel = arr[j];
                personalModel.isSelected = orgmodel.isSelected;
            }
        }
        [_contentTableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSLog(@"点击了科室");
    }else{
        NSInteger index = checkBox.tag - 100;
        
        CCityNewNotficPersonModel * headerModel =  _dataArr[index];
        headerModel.isOpen = !headerModel.isOpen;
        headerModel.isSelected = !headerModel.isSelected;
        
        for (int i = 0; i < headerModel.orgModelArr.count; i ++) {
            CCityNewNotficPersonModel * orgmodel = headerModel.orgModelArr[i];
            orgmodel.isOpen = headerModel.isOpen;
            orgmodel.isSelected = headerModel.isSelected;
            
            NSArray * letterArr = headerModel.personalModelFirstLetterArr[i];
            NSDictionary * dic =  headerModel.personalModelFormatArr[i];
            
            for (int k = 0; k < letterArr.count ; k ++) {
                NSString * keyValue = letterArr[k];
                NSMutableArray * arr = dic[keyValue];
                for ( int j = 0; j < arr.count; j ++) {
                    CCityNewNotficPersonModel * personalModel = arr[j];
                    personalModel.isSelected = orgmodel.isSelected;
                }
            }

        }

        [_contentTableView reloadSection:index withRowAnimation:UITableViewRowAnimationAutomatic ];
        NSLog(@"点击了全部部门人");
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
