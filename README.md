# MKOAirdropActivityViewController
This is basically a **view hierarchy hack** of the UIActivityViewController to hide the sharing sections below the Airdrop field. With the introduction of sharing extensions in iOS8 it is currently not possible to hide those sections using the **excludedActivityTypes** property anymore.

I currently use it in a side project as an intermediate solution. It was tested with iOS9. 

**Note:** This hack doesn't use any private API. But the view structure of UIActivityViewController might change with any future release, so it is **not recommended** to use this in production.

<div>
<img width=300 src="https://raw.githubusercontent.com/mkoehnke/MKOAirdropActivityViewController/master/Resources/Image-0.jpg?token=ABXNjVNuPSVGXStcN6FRPRJrMHXofWuzks5Vjk7swA%3D%3D">
<img width=300 src="https://raw.githubusercontent.com/mkoehnke/MKOAirdropActivityViewController/master/Resources/Image-1.jpg?token=ABXNjSp-2-xn5OjT5wcbVNYL6aGAvtFNks5Vjl7uwA%3D%3D">
</div>

# Author
Mathias Köhnke [@mkoehnke](http://twitter.com/mkoehnke)

# License
MKOAirdropActivityViewController is available under the MIT license. See the LICENSE file for more info.

# Recent Changes
The release notes can be found [here](https://github.com/mkoehnke/MKOAirdropActivityViewController/releases).