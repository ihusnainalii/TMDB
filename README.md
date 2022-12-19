# TMDB
A simple app to hit the themovie db API and:
* Show a list of movies from api or local cache data which is stored in realm db
* List of movies are paginated 
* Movies can be made favorite 
* User can unfavorite the movie based on this interest 
* Shows details when items on the list are tapped
* Live seearch (update results on characters change)
* Seearch with pagination 
* Auto suggest list view will display the search box showing last 10 successful queries
* Suggestions are persisted.
* Internet connection checked along with other data handling

i am using following APIs for above functionalities.
1. Movie List:
https://api.themoviedb.org/3/movie/popular?api_key=e5ea3092880f4f3c25fbc537e9b37dc 1
2. Search Movie: 
https://api.themoviedb.org/3/search/movie?api_key=e5ea3092880f4f3c25fbc537e9b37dc1&query=[Movie_name]&page=1
3. Poster image: 
https://image.tmdb.org/t/p/w92/[poster_path]
 
i have used MVVM Design pattern with RxSwift and swift generic approach to develop this application.

&nbsp; 
**App Flow:**
&nbsp; 
&nbsp; 

<kbd >
<img src="https://github.com/ihusnainalii/TMDB/blob/main/TMDB/Screenshots/Recording.gif">
</kbd>

&nbsp; 
&nbsp;  

## Tools And Resources Used

- [CocoaPods](https://cocoapods.org/) - CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects. It has over 33 thousand libraries and is used in over 2.2 million apps. CocoaPods can help you scale your projects elegantly.


## Library Used
- [Kingfisher](https://github.com/onevcat/Kingfisher) - This library provides an async image downloader with cache support.
- [MBProgressHUD](https://github.com/jdg/MBProgressHUD) - This library provides customize loading view.
- [Alamofire](https://github.com/Alamofire/Alamofire) - This library for neetwork handling.
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) - This library provides an async image downloader with cache support.
- [RxSwift & RxCocoa](https://github.com/ReactiveX/RxSwift) - This library provides a reactive Programming support in Swift .


&nbsp; 

# Installation
* Installation by cloning the repository
* Go to directory
* use command + B or Product -> Build to build the project
* Incase of build fail due to dependency, install CocoaPods using pod install in the project directory.
* Press run icon in Xcode or command + R to run the project on Simulator

&nbsp; 

# Architecture

i have used MVVM clean with RxSwift:

&nbsp; 
&nbsp; 

<kbd >
<img src="https://user-images.githubusercontent.com/15336778/41942613-a4008032-79bd-11e8-98b5-a40e7d871203.png" width="80%" height="80%">
</kbd>

</br>
</br>

# MIT License

Copyright 2018

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
