# SinaWBUserCenter
微博个人主页UI实现

# 下面是效果图
![](http://o81omrb7h.bkt.clouddn.com/1.gif)

#简介
- 容器是一个container viewcontroller；
- 主页，微博，相册3个section分别对应3个tableviewcontroller，这三个viewcontroller通过addChildViewController来进行切换显示；
- 三个tableview共用1个headerView,通过监听tableview的scroll delegate来控制headerview的显示位置；
- 详细的请看代码。

#PS 
有问题请发邮件或issue！！！感谢
