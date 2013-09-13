//
//  BaseTableView.m
//  WXWeibo
//
//  Created by cannaan on 13-7-9.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

// 代码创建的时候回调用呢initView
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initView];
    }
    return self;
}

// xib调用的情况，步调用上面的initWithFrame
- (void)awakeFromNib{
    [self _initView];
}

- (void)_initView{
    _freshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _freshHeaderView.delegate = self;
    _freshHeaderView.backgroundColor = [UIColor clearColor];
    
    self.dataSource = self;
    self.delegate = self;
    self.refreshHeader = YES;
    
    // 加载尾部视图
    _moreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];// 取得所有权，否则自动释放池管理
    _moreButton.backgroundColor = [UIColor clearColor];
    _moreButton.frame = CGRectMake(0, 0, ScreenWidth, 40);// 高度可以bu设定
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setTitle:@"上拉加载更多" forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(100, 10, 20, 20);
    activityView.tag = 2013;
    [activityView stopAnimating];// 禁止转动
    [_moreButton addSubview:activityView];
    
    //[self.tableFooterView addSubview: _moreButton];//直接赋值，不是子视图！默认情况footerView尚未出现。
    self.tableFooterView = _moreButton;// 两种方法都可以么？
    
}

- (void)setRefreshHeader:(BOOL)refreshHeader{

    _refreshHeader = refreshHeader;
    if (_refreshHeader) {
        [self addSubview:_freshHeaderView];
    }else{
    
        if ([_freshHeaderView superview]) {
            [_freshHeaderView removeFromSuperview];
        }
    }
}
// 自动更新数据
- (void)refreshData{
    [_freshHeaderView initLoading:self];
}

- (void)_starLoadMore {
    
    [_moreButton setTitle:@"正在加载..." forState:UIControlStateNormal];
        _moreButton.enabled = NO;
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2013];
    [activityView startAnimating];
}

- (void)_stopLoadMore {
    // 11
    if (self.data.count > 0) {
        _moreButton.hidden = NO;
        [_moreButton setTitle:@"上啦加载..." forState:UIControlStateNormal];
        _moreButton.enabled = YES;
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2013];
        [activityView stopAnimating];
        
        if (!self.isMore) {
             [_moreButton setTitle:@"加载完成" forState:UIControlStateNormal];
            _moreButton.enabled = NO;
        }
    }else {
        _moreButton.hidden = YES;
    }
}
// 覆写
- (void)reloadData {
    [super reloadData];
    // 停止加载更多
    [self _stopLoadMore];
}

#pragma mark - actions
- (void)loadMoreAction {
    if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
        [self.eventDelegate pullUp:self];
        [self _starLoadMore];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_freshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
// 当滑动时，实时调用此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_freshHeaderView egoRefreshScrollViewDidScroll:scrollView];   
    
}
// 手指停止拖拽的时候调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_freshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if (!self.isMore) {
        return;
    }
    //手指放开时候的时候偏移量
    
    float offset = scrollView.contentOffset.y;// 偏移量
    float contentHeight = scrollView.contentSize.height;
    // 当偏移量滑到最底部时候，差值是scrollView的高度
    float sub = contentHeight - offset;
    if ((sub - scrollView.height)>30) {
        [self _starLoadMore];
        if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
            [self.eventDelegate pullUp:self];
        }
       
    }
}

#pragma mark - 下拉相关方法。
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    // 手指放开的时候申请代理执行该代理方法。
    if ([self.eventDelegate respondsToSelector:@selector(pullDown:)]) {
        [self.eventDelegate pullDown:self];
	}
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}



#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.eventDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}
@end
