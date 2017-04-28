# OkWebViewController
######一、版本适配问题
在真实的开发中我们可能对UIWebView“爱不释手”，因其调用简单，使用方便，但其会占用程序的大量内存，加载速度慢，体验效果并不是很好，WKWebView为iOS8推出的网页展示视图，相比UIWebView，其占用的内存更小，请求效率更高，因此极力推荐大家使用WKWebView。

因此在网页视图的创建方面首先进行版本适配，对于大于iOS8的系统我们采用WKWebView，反之使用UIWebView。
```
- (void)createWebView {
self.automaticallyAdjustsScrollViewInsets = NO;
if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
[self.view addSubview:self.wk_WebView];
} else {
[self.view addSubview:self.webView];
}
}

```
######二、导航按钮快捷设置（返回&&关闭）
该功能的实现比较简单，我们可以根据webView或wk_webView的goBack方法进行判断，检测当前网页是否存在可返回的上一界面，若存在显示返回与关闭按钮，若不存在显示返回按钮即可。
```
- (void)showLeftBarButtonItem {
if ([_webView canGoBack] || [_wk_WebView canGoBack]) {
self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem,self.closeBarButtonItem];
} else {
self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
}
}
```
closeBarButtonItem所处理的事件为关闭界面操作即
```
- (void)close:(UIBarButtonItem*)item {
[self.navigationController popViewControllerAnimated:YES];
}
```
backBarButtonItem需根据网页是否可返回前一界面触发返回前界面或关闭操作
```
- (void)back:(UIBarButtonItem*)item {
if ([_webView canGoBack] || [_wk_WebView canGoBack]) {
[_webView goBack];
[_wk_WebView goBack];
} else {
[self.navigationController popViewControllerAnimated:YES];
}
}
```
在这里我们也可以对导航栏标题进行设置，使其为当前网页标题，在网页加载完成方法中简单调用JS语句document.title即可，webView与WkWebView调用JS方法有所区别，如下代码所示：
```
//WebView
self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
```

```
//WkWebView
[webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
self.navigationItem.title = title;
}];
```
对于WKWebView我们还可以通过监听title属性进行实现。
######三、修复自定义导航按钮侧滑手势失效
在第二步我们手动设置了导航栏左按钮，因此我们会发现系统自带的侧滑返回功能失效了，为了可实现网页的侧滑返回功能，我们需要修复其失效的问题。
```
- (void)viewWillAppear:(BOOL)animated {
[super viewWillAppear:animated];
if (self.navigationController.viewControllers.count > 1) {
self.delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
}

- (void)viewWillDisappear:(BOOL)animated {
[super viewWillDisappear:animated];
self.navigationController.interactivePopGestureRecognizer.delegate = self.delegate;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
return self.navigationController.viewControllers.count > 1;
}
```
######四、侧滑手势返回上层网页功能
对于WKWebView系统为我们提供了很好的一种实现效果，设置WkWebView的allowsBackForwardNavigationGestures为YES即可开启屏幕左边缘右滑返回与屏幕右边缘左滑返回效果。（PS：楼主曾花费一整天的时间尝试实现这个效果，没想到苹果已准备好了(╯‵□′)╯︵┻━┻ ）
```
_wk_WebView.allowsBackForwardNavigationGestures = YES;
```
######五、网页加载进度显示功能
对于WKWebView我们可以使用KVO监听属性estimatedProgress即可获取加载进度的变化，而对于UIWebView推荐使用[NJKWebViewProgress](https://github.com/ninjinkun/NJKWebViewProgress)进行添加。
```
[_wk_WebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
if ([keyPath isEqualToString:@"estimatedProgress"]) {
_loadingProgressView.progress = [change[@"new"] floatValue];
if (_loadingProgressView.progress == 1.0) {
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
_loadingProgressView.hidden = YES;
});
}
}
}
```
既然添加了监听，因此不要忘记在dealloc中进行移除
```
- (void)dealloc {
[_wk_WebView removeObserver:self forKeyPath:@"estimatedProgress"];
}
```
######六、网页下拉刷新（iOS10新特性）
iOS10中为ScrollView添加了下拉刷新控件，而WebView里层控件即为ScrollView，因此我们可以为网页添加下拉刷新功能。这里选择使用系统原生控件UIRefreshControl，考虑某些网页页面并不需要下拉刷新功能，因此已公开BOOL加以限制，如需要可手动置为YES。
```
//添加下拉刷新
if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0 && _canDownRefresh) {
_wk_WebView.scrollView.refreshControl = self.refreshControl;
}
```
######七、请求异常占位图问题
在网址请求失败或显示空白页面时需显示占位图提示用户。我们分别需要在网页请求失败以及开始加载时加以判断。以WKWebView为例。
```
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
webView.hidden = YES;
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
webView.hidden = NO;
_loadingProgressView.hidden = NO;
//不加在空白网页
if ([webView.URL.scheme isEqual:@"about"]) {
webView.hidden = YES;
}
}
```
