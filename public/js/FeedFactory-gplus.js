var FeedFactory = function(data){
	//this.data=data;
	this.leftHeight=0;
	this.rightHeight=0;
	var layouts = {gplus:"col-xs-12 col-sm-5 col-md-5 clearfix"};
	this.layout = layouts.gplus;

	var env = findBootstrapEnvironment();
	this.isPhone = (env=="xs" /*|| env == 'sm'*/) ;
	this.app = $('#pageloading').length!=0
	//var isApp =

	binding(this.app);
}

FeedFactory.prototype.append =function(data){
	//var data = this.data;
	//var keys = Object.keys(data);

	//var leftHeight=0;
	//var rightHeight=0;

	for(var i=0;i<data.length;i++){
		var f = data[i];
		if(f.source_type=="facebook"){
			//f[0]['story']==undefined &&
			//if((f.fb_type=="status" || f.fb_type=="link") && f.social_id.indexOf(f.fb_from_id)==0){

			if(f.fb_type!=null && f.uid_url.indexOf(f.fb_from_id)==0){
				var root = $("<div>");
				root.attr("id","_f"+i);
				root.addClass(this.layout);

				var panel = $("<div>");
				panel.addClass("panel");
				panel.addClass("panel-default");
				panel.appendTo(root);

				var head = $("<div>");
				head.addClass("panel-heading");
				head.addClass("hsource");
				head.appendTo(panel);
/*
				var more = $("<a>");
				more.addClass("pull-right");
				more.attr("href","#");
				more.text(f.topic);
				more.appendTo(head);
*/
				/*var share = $("<a>");
				share.addClass("pull-right");
				share.attr("href","#");
				share.text("share");
				share.appendTo(head);*/


				var subject = $("<h4>");
				//FIXME RENDER SUBJECT ABOUT THIS SOURCE / CONTENT
				subject.text(f.fb_from_name);
				subject.appendTo(head);
				subject.addClass("sourcecard");

				var topic = $("<small>");
				topic.appendTo(head);

				var more = $("<a>");
				more.attr("href","#");
				more.text(f.topic);
				more.appendTo(topic);


				var timeAgo = $("<small>");
				timeAgo.text(" - "+when(f.published));
				timeAgo.appendTo(head);
				timeAgo.addClass("ago");

				var body = $("<div>");
				body.addClass("panel-body");
				//body.addClass("contenth");
				body.appendTo(panel);

				var richTitle = $("<h4>");

				var title = $("<p>");

				var titleText =f.title ? f.title : (f.fb_message ? f.fb_message : "")

				richTitle.text(titleText);
				richTitle.appendTo(body);
				richTitle.addClass("titlecard");

				var rich = $("<div>");
				rich.addClass("rich-content");
				rich.appendTo(body);

				if(f.fb_pic){
					var richHolder = $("<div>");
					richHolder.appendTo(rich);

					var video = $("<div>");
					video.attr("id","video");
					video.addClass("hidden");
					video.appendTo(richHolder);

					var imgHolder = $("<div>");
					imgHolder.attr("id","img");
					imgHolder.appendTo(richHolder);

					var aContent = $("<a>");
					aContent.addClass("lg");
					aContent.attr("href",f.fb_link);
					aContent.attr("target","_blank");
					aContent.appendTo(imgHolder);

					var img = $("<img>");
					img.addClass("pull-left");
					img.attr("src", makeImgBigger(f.fb_pic));
					img.appendTo(aContent);
					img.attr("style", "height:250px;");

					var richContentHolder = $("<div>");
					richContentHolder.addClass("rich-content-holder");
					richContentHolder.appendTo(richHolder);

					var richDesc = $("<h4>");
					richDesc.appendTo(richContentHolder);
					richDesc.addClass("desccard");
					if(f.description){
						var small = $("<small>");
						small.text(f.description.substring(0,255) + "...");
						small.appendTo(richDesc);
					}
				}

				var hrefId = f.uid_url + f.published;

				var sharelink = $("<a>");
				sharelink.text("Compartilhar");
				sharelink.attr("data-toggle","collapse");
				sharelink.attr("href","#" + hrefId);
				sharelink.attr("aria-expanded","false");
				sharelink.attr("aria-controls",f.uid) ;
				sharelink.appendTo(richHolder);

				var share=socialShare(hrefId);
				share.appendTo(richHolder);//FIXME MAYBE MOVE TO CODE ABOVE

				root.appendTo($("#feed"));


				var height = $(root).height();
				var cssCurrentPos = "";

				if(this.rightHeight < this.leftHeight){
					cssCurrentPos = "top:"+this.rightHeight+"px;right:0px";
					this.rightHeight += height;
					root.addClass("pull-right");
					//root.addClass("pull-right col-md-pull-1");
				}else if(this.leftHeight <= this.rightHeight){
					cssCurrentPos = "top:"+this.leftHeight+"px;left:0;";
					root.addClass("pull-left");
					this.leftHeight += height;
					root.addClass("col-md-offset-1");
					//root.addClass("pull-lfet col-md-offset-1");
				}

				if(this.isPhone){
					root.attr("style","display:inline-block;"); //use this to expand share button properly to don't mess the feed
				}else{
					root.attr("style","display:inline-block;position:absolute;"+cssCurrentPos); //use this to expand share button properly to don't mess the feed
					//root.attr("style","display:inline-block;position:absolute;top:"+this.rightHeight+"px;right:0px"); //use this to expand share button properly to don't mess the feed
					//root.attr("style","display:inline-block;position:absolute;top:"+this.leftHeight+"px;left:0;"); //use this to expand share button properly to don't mess the feed
				}
			}
		}else if(f.source_type == "google_oauth2"){
			var root = $("<div>");
			root.addClass(this.layout);

			var panel = $("<div>");
			panel.addClass("panel");
			panel.addClass("panel-default");
			panel.appendTo(root);

			var head = $("<div>");
			head.addClass("panel-heading");
			head.appendTo(panel);

			var more = $("<a>");
			more.addClass("pull-right");
			more.attr("href","#");
			more.text("more");
			more.appendTo(head);

			var subject = $("<h4>");
			subject.text(f.ytb_channel_name);
			subject.appendTo(head);

			var timeAgo = $("<small>");
			timeAgo.text(when(f.published));
			timeAgo.appendTo(head);

			var body = $("<div>");
			body.addClass("panel-body");
			body.appendTo(panel);

			var rich = $("<div>");
			rich.addClass("rich-content");
			rich.appendTo(body);

			var richHolder = $("<div>");
			richHolder.appendTo(rich);

			var video = $("<div>");
			video.attr("id","video");
			video.addClass("hidden");
			video.appendTo(richHolder);

			var imgHolder = $("<div>");
			imgHolder.attr("id","img");
			imgHolder.appendTo(richHolder);

			var aContent = $("<a>");
			aContent.addClass("lg");
			aContent.attr("href","http://www.youtube.com/watch?v="+f.ytb_videoid);
			aContent.appendTo(imgHolder);

			var img = $("<img>");
			if(f.ytb_thumbnail){
				img.addClass("pull-left");
				img.attr("src",f.ytb_thumbnail);
				img.attr("style", "height:250px;");
				img.appendTo(aContent);
			}

			var richContentHolder = $("<div>");
			richContentHolder.addClass("rich-content-holder");
			richContentHolder.appendTo(richHolder);

			var richTitle = $("<h4>");
			richTitle.text(f.title ? f.title : "");
			richTitle.appendTo(richContentHolder);

			var richDesc = $("<h4>");
			richDesc.appendTo(richContentHolder);

			var small = $("<small>");
			small.text(f.description.substring(0,255));
			small.appendTo(richDesc);

			root.appendTo($("#feed"));

		    var height = $(root).height();
			if(this.rightHeight < this.leftHeight){
				//console.log(i + " right: " + height);
				this.rightHeight += height;
				root.attr("style","display:inline-block;float:right");
			}else if(this.leftHeight <= this.rightHeight){
				//console.log(i + " left: " + height);
				this.leftHeight += height;
				root.attr("style","display:inline-block;float:left");
			}
		}
	}

	function makeImgBigger(url){
		//console.log(url.replace(/&w=\d+/,'').replace(/&h=\d+/,''))
		//return url.replace(/&w=\d+/,'').replace(/&h=\d+/,'')
		return url
	}

	function socialShare(id){
		var holder=$("<div>");
		holder.addClass("container");
		holder.addClass("social-container");
		holder.addClass("collapse")
		holder.attr("id", id)

		var row = $("<div>");
		row.addClass("row-fluid");
		row.appendTo(holder);

		//var names = ["fb", "twt", "gp", "lk"];

		var names = {
			fb: {
				name: "Facebook",
				url: "window.open('https://www.facebook.com/dialog/feed?app_id=524656474329640&display=popup&caption=An%20example%20caption&link=http://www.4linked.com&redirect_uri=http://www.4linked.com/share_redir','','width=600, height=300');return false;"
			},
			twt: {
				name: "Twitter",
				url: "window.open('https://twitter.com/intent/tweet?url=http://www.4linked.com&via=4Linked&related=', '', 'width=600, height=300');return false;"
			},
			gp: {
				name: "Google+",
				url: "window.open('https://plus.google.com/share?url=http://www.4linked.com&title=http://www.4linked.com', '', 'width=600, height=300');return false;"
			},
			lk: {
				name: "Linkedin",
				url: "window.open('https://www.linkedin.com/shareArticle?mini=true&url=http://www.4linked.com&title=http://www.4linked.com&summary=http://www.4linked.com&source=http://www.4linked.com', '', 'width=600, height=300');return false;"
			},
			rd: {
				name: "Reddit",
				url: "window.open('https://reddit.com/submit?url=http://www.4linked.com&title=http://www.4linked.com/', '', 'width=600, height=300');return false;"
			},
			pi:{
				name: "Pinterest",
				url: "window.open('https://pinterest.com/pin/create/button/?url=http://www.4linked.com&media=http://www.4linked.com/me.jpg&description=description here', '', 'width=600, height=300');return false;"
			}
		}

//have a look on tumblr
//<a href="https://plus.google.com/share?url={URL}" onclick="javascript:window.open(this.href,
//  '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;"><img
//  src="https://www.gstatic.com/images/icons/gplus-64.png" alt="Share on Google+"/></a>

		//for(var i=0;i<names.length;i++){
		for(var key in names){
			var social = $("<div>");
			social.addClass("social-holder");
			social.appendTo(row);

			var button=$("<button>");
			button.addClass("btn-social");
			button.attr("title","Share to "+ names[key].name +". Opens in a new window.");
			button.attr("data-toolttip-text","Share to "+ names[key].name +". Opens in a new window.");
			button.attr("onclick",names[key].url);

			var type = $("<span>");
			type.addClass(key+"social-icon");
			type.addClass("social-icon");
			type.addClass("social-sprite");
			type.appendTo(button);

			button.appendTo(social);
		}

		return holder;
	}
}

function findBootstrapEnvironment() {
	var envs = ['xs', 'sm', 'md', 'lg'];
	    $el = $('<div>');
	    $el.appendTo($('body'));

	    for (var i = envs.length - 1; i >= 0; i--) {
	        var env = envs[i];

	        $el.addClass('hidden-'+env);
	        if ($el.is(':hidden')) {
	            $el.remove();
	            return env
	        }
	    };
}

function binding(app){
	$(document).on('click','a.lg',function(e){
	  //http://css-tricks.com/NetMag/FluidWidthVideo/Article-FluidWidthVideo.php
	  e.preventDefault();
	  e.stopPropagation();

	  var href=$(this).attr("href").replace(/&.*$/,"");

	  if(href.indexOf("https://www.youtube.com")==0 || href.indexOf("http://www.youtube.com")==0
	  || href.indexOf("http://youtube.com")==0 || href.indexOf("https://youtube.com")==0
	  || href.indexOf("https://youtu.be")==0 || href.indexOf("http://youtu.be")==0){

	    if(href.indexOf("https://youtu.be")==0 || href.indexOf("http://youtu.be")==0){
	      href=href.replace(/https?:\/\/.*\//,"");
	    }else{
	      href=href.replace(/https?:\/\/.*\/watch\?v=/,"");
	    }

	  	var videoContainer = $(this).parent().parent().find("#video");
	    var iframe=$('<iframe>', {
	     src: ("http://www.youtube.com/embed/" + href + "?autoplay=1"),
	     frameborder: 0,
	     scrolling: 'no'
	     }).appendTo(videoContainer);

	      $(this).parent().closest('#img').fadeOut( "fast",function(){
			$(this).addClass("hidden");
	          $(videoContainer).fadeOut( "fast",function(){
	            $(videoContainer).removeClass("hidden");
	          })
	      })
	    }else{
				if(app){
					window.open(href,"_system");
				}
				else
					window.open(href,"_blank");
	    }
	});
}


//$.getScript('js/time.js', function() {});

/*
  var $allVideos = $("iframe[src^='http://www.youtube.com']"),

  // The element that is fluid width
  $fluidEl = $("body");

  // Figure out and save aspect ratio for each video
  $allVideos.each(function() {

  $(this)
    .data('aspectRatio', this.height / this.width)

  // and remove the hard coded width/height
  .removeAttr('height')
  .removeAttr('width');

  });

  // When the window is resized
  $(window).resize(function() {

  var newWidth = $fluidEl.width();

  // Resize all videos according to their own aspect ratio
  $allVideos.each(function() {

    var $el = $(this);
    $el
      .width(newWidth)
      .height(newWidth * $el.data('aspectRatio'));

  });

  // Kick off one resize to fix all videos on page load
  }).resize();
 */
