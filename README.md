这里讲解一下怎么讲效果集成到自己的项目中去，这里先上效果图

![image](https://github.com/Andrewliu20/andrewliu/blob/master/img/QQ20170323-100126-HD.gif ) 

这里建议下载SDWebImage这个三方库后再导入项目中，因为这里需要对库进行添加这里不建议通过pod添加该库，以防更新后添加的方法不存在。

这里第一步需要在下载图片的时候在sd_setImageWithURL的completed 的block中添加如下代码实现如图
![image](https://github.com/Andrewliu20/andrewliu/blob/master/img/D8C7925A-2300-4B30-B180-548BFB602B68.png)
在上图中，实现图片加载优化的效果代码是通过UIView的特性实现的效果，如图
![iamge](https://github.com/Andrewliu20/andrewliu/blob/master/img/845BC1E5-D145-4879-A312-34A57E08BE98.png)
那现在讲讲在第一步中的diskImageExistsForURL的作用：这里这个方法的具体目的是实现对已加载的图片做的缓存处理，已存在的缓存图片加载时不再有这样的显示效果。
