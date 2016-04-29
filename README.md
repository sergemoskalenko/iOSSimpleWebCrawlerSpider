# iOSSimpleWebCrawlerSpider

GOOGLE TRANSLATION of russian source: https://github.com/sergemoskalenko/iOSSimpleWebCrawlerSpider/blob/master/README-ru.md


Application iOS - Web Spider

The goal - recursive search for the specified text starting with the specified page on the Internet.

you need to determine for each page, how many times it occurs in the specified text.
Then find all the hyperlinks of the form http: // *, https: // * to this page and for them recursively
to do the same. Pages in the queue should not be duplicated.

The search is performed asynchronously in multiple threads. It must be possible to interrupt,
pause and continue. The search is performed on the column of links in depth
within a specified level.

Input data
• the start page (for example, http://www.bbc.com/)
• Key text (eg, Ukraine)
• limit the number of results (1 to 500)
• the maximum search depth (1 to 5)
• the number of threads (1 to 8)

Displaying the results
• general information - the number of active streams, the total number of scanned
pages, number of pages with the found text
• A list, each element of which shows search results - the address of the page, in
Queue / finished, the number of occurrences of the text or error userfriendly
• the application must maintain responsiveness when scrolling.

The application consists of one screen. The upper part contains controls.
Screen Design on the applicant's discretion.


![img1](https://github.com/sergemoskalenko/iOSSimpleWebCrawlerSpider/blob/master/ios-spider0-6.jpg?raw=true) ![img2](https://github.com/sergemoskalenko/iOSSimpleWebCrawlerSpider/blob/master/ios-spider1-6.jpg?raw=true)

**iOS Simple Web Crawler Spider** run online in your web browser:

https://appetize.io/app/wp4ttu0gh0u9cqgdz4rmkmkn18
