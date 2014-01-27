FingerTweet
===========

I noticed a similarity in how twitter is used today compared to old
.project and .plan files over the [Finger protocol](http://en.wikipedia.org/wiki/Finger_protocol).
But I wanted a way to capture that information without having it get pushed down
by all of those [great](http://giphy.com/gifs/iShafmfAZk5XO) [cat](http://giphy.com/gifs/Mhy9hKgfwI0lG)
[GIFs](http://giphy.com/gifs/wQI5H4jtqZEPK).

Development
-----------

```
bundle install
rake db:create:all db:migrate db:test:prepare
rspec
rails s
```

If you intend to modify the twitter interaction for the app you'll need your own [twitter api key](https://dev.twitter.com/apps/new).
You can set these variables within ```config/local/twitter.yml``` in the same format as ```config/twitter.yml```.
