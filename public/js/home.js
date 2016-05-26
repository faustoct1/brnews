//var remote = "http://brnews.herokuapp.com";
var remote = "http://www.brnews.co";
//var remote = "http://localhost:3000";

angular.module('home',[])

.factory('_FeedFactory', function($http) {
	//=>http://blog.revolunet.com/blog/2014/02/14/angularjs-services-inheritance/
  var Feed = function(type) {
      this.type = type;
      this.token=null;
      this.url=null;
      this.observerCallbacks = [];
      this.feed=new FeedFactory()
  };

  //call this when you know 'foo' has been changed
  Feed.prototype.notifyObservers = function(){
    angular.forEach(this.observerCallbacks, function(callback){
      callback();
    });
  };

  //register an observer
  Feed.prototype.registerObserverCallback = function(callback){
    this.observerCallbacks.push(callback);
  };

  //example of when you may want to notify observers
  /*Feed.prototype.foo = someNgResource.query().$then(function(){
    notifyObservers();
  });*/

  Feed.prototype.init = function(){
		var token = this.token;
    var topic=$("#feedstory").attr("topic");
    var that = this;
    var url = (remote+'/me/')
    this.url = url

    this.next(0)
	};

	Feed.prototype.next= function(p){
    var that = this
    call(this.url + p,function (d){
      that.feed.append(d);
      that.notifyObservers();
    })
	};

  Feed.prototype.ads= function(){
    this.feed.ads()
  };

	function call(url,f){
    $http.get(url).then(function(d) {f(d['data'])});
	}

  return Feed;
})


.controller('InitHome',function($scope){
	$(document).ready(function(){//off-canvas sidebar toggle
		$('[data-toggle=offcanvas]').click(function() {
		$(this).toggleClass('visible-xs text-center');
		$(this).find('i').toggleClass('glyphicon-chevron-right glyphicon-chevron-left');
		$('.row-offcanvas').toggleClass('active');
		$('#lg-menu').toggleClass('hidden-xs').toggleClass('visible-xs');
		$('#xs-menu').toggleClass('visible-xs').toggleClass('hidden-xs');
		$('#btnShow').toggle();
		});
	});
})

.controller('NewsFeed', function ($scope,_FeedFactory){
	$scope.feed = null;
	$scope.page = 0;
	$scope.blocked = false;
	$scope.currentHeight=0;
  $scope.feedloading = null;
  $scope.hideFeedLoading = true;

	$(document).ready(function(){
		if($scope.feed==null){
      $scope.feed = new _FeedFactory();
      $scope.feed.registerObserverCallback(function(){
        if(!$scope.hideFeedLoading){
          $scope.feedloading.addClass('hide');
          $scope.hideFeedLoading = true;
        }
      });

      if(!$scope.feedloading){
        $scope.feedloading = $("#feedloading");
        $scope.feedloading.offset({top: $(document).height()-40}) ;
      }
    }

    $scope.feed.init();

		$( window ).scroll(function() {
      var height=$(document).height() - $(window).height();
      var bottom = $(window).scrollTop() == (height);

			if((bottom) && !$scope.blocked){
        $scope.feedloading.removeClass('hide');
        $scope.hideFeedLoading = false;

        $scope.blocked=true;
        $scope.loadMore();
        $scope.currentHeight=height;

			}else if($scope.blocked){
				if($scope.currentHeight<height){
					$scope.blocked=false;
				}
			}
		});
	});

	$scope.loadMore = function() {
		$scope.page++;
    //$scope.feed.ads();
		$scope.feed.next($scope.page);
  };

  /*$scope.$watch( function () { return $scope.feed.currentPage; }, function (data) {
    $scope.lastUpdated = data.lastUpdated;
    $scope.calls = data.calls;
  }, true);*/
});
