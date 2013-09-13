

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class BaseTableView;
@protocol UITableViewEventDelegate <NSObject>

@optional
// 下拉
- (void)pullDown:(BaseTableView *)tableView;
// 上拉
- (void)pullUp:  (BaseTableView *)tableView;
// 选中一个cell
- (void)tableView:(BaseTableView *)tableView
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface BaseTableView : UITableView<EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    EGORefreshTableHeaderView *_freshHeaderView;
    UIButton *_moreButton;
    BOOL                      *_reloading;
}

@property (nonatomic,assign)BOOL refreshHeader;  //是否需要下拉
@property (nonatomic,retain)NSArray *data;// 为tableView提供数据
@property (nonatomic,assign)id<UITableViewEventDelegate> eventDelegate;

@property (nonatomic,assign)BOOL isMore;   // 是否还有更多下一页

- (void)doneLoadingTableViewData;
- (void)refreshData;
@end
