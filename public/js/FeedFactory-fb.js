var FeedFactory = function(data){
	//this.data=data;
	this.leftHeight=0;
	this.rightHeight=0;
	//var layouts = {gplus:"col-xs-12 col-sm-5 col-md-5 clearfix"};
	//this.layout = layouts.gplus;
	var layouts = {fb:"col-xs-12 col-sm-9 col-md-6 col-lg-5 col-md-offset-2 col-lg-offset-3 col-sm-offset-2 clearfix lrg"};
	this.layout = layouts.fb;

	var env = findBootstrapEnvironment();
	this.isPhone = (env=="xs" /*|| env == 'sm'*/) ;
	this.app = $('#pageloading').length!=0
	//var isApp =

	binding(this.app);
}

FeedFactory.prototype.ads = function(){
	var downloadapp = $("<div class='row' style='margin-bottom:20px'>");
	var downloadlink = $("<a>");
	var downloadimg = $("<img>");

	downloadimg.attr('src','https://developer.android.com/images/brand/pt-br_generic_rgb_wo_45.png')
	downloadlink.attr('href','https://play.google.com/store/apps/details?id=com.linked4')

	downloadapp.addClass(this.layout);
	downloadlink.appendTo(downloadapp)
	downloadimg.appendTo(downloadlink)
	downloadapp.appendTo($("#feed"))
}

FeedFactory.prototype.append =function(data){
	for(var i=0;i<data.length;i++){
		var f = data[i];
		if(f.source_type=="facebook"){
			//f[0]['story']==undefined &&
			//if((f.fb_type=="status" || f.fb_type=="link") && f.social_id.indexOf(f.fb_from_id)==0){

			if(f.fb_type!=null && f.uid_url.indexOf(f.fb_from_id)==0){
				var row = $("<div class='row'>");
				row.attr("id","_f"+i);

				var root = $("<div>");
				//root.attr("id","_f"+i);
				root.addClass(this.layout);
				root.appendTo(row)

				var overlay = $('<div>')
				overlay.appendTo(root)
				overlay.css("margin-bottom","20px")

				var aContent =null
				if(f.fb_full_pic != null){
					aContent = $('<a style="display:block;position:relative;border-bottom: 1px solid #ddd; background-image:url('+f.fb_full_pic+'); height: 300px; text-shadow: 0 0 0.1px #000; color:#fff; background-repeat:no-repeat;background-size:100% 100%"></a>');
				}else{
					aContent = $('<a>')
				}

				aContent.addClass("list-group-item card-topic btn-topic"+f.topic_id);
				aContent.attr("href",f.fb_link);
				aContent.attr("share-link",f.qtitle);
				aContent.attr("target","_blank");
				aContent.appendTo(overlay);

				bshare(aContent)

				var _overlay = $("<div>")
				_overlay.appendTo(aContent)

				if(f.fb_full_pic != null){
					overlay.addClass("oi")
					_overlay.addClass("b")
				}

				var hrefId = f.uid_url + f.published;

				var subject = $("<h5>");
				var ssubject = $("<strong>")
				subject.appendTo(ssubject)
				subject.addClass('list-group-item-text')
				ssubject.text(f.topicn)
				ssubject.appendTo(subject)
				subject.appendTo(_overlay)

				//var shar = $("<span>")
				//shar.addClass("pull-right glyphicon glyphicon-share-alt shar")
				//shar.appendTo(subjectHolder)

				var title = $("<h4>");
				title.addClass('list-group-item-text')
				title.text(f.title ? f.title : (f.fb_message ? f.fb_message : ""))
				title.appendTo(_overlay)

				var who = $("<h6>");
				who.addClass('list-group-item-text')
				who.appendTo(_overlay)

				who.text(f.fb_from_name + " há " + when(f.published))

				row.appendTo($("#feed"));
			}
		}
	}

	function makeImgBigger(url){
		//console.log(url.replace(/&w=\d+/,'').replace(/&h=\d+/,''))
		//return url.replace(/&w=\d+/,'').replace(/&h=\d+/,'')
		return url
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

/*function binding(app){
	$(document).on('click','a.lg',function(e){
	  //http://css-tricks.com/NetMag/FluidWidthVideo/Article-FluidWidthVideo.php
	  e.preventDefault();
	  e.stopPropagation();

	  var href=$(this).attr("href").replace(/&.*$/,"");

		if(app){
			window.open(href,"_system");
		}
		else{
			window.open(href,"_blank");
		}
	});

	$(document).on('click','a.sharex',function(e){
		$('#content2share').data('title',$(this).data('title'))
		$('#sharemodal').modal().show()
	})
}*/

function bshare(parent){
	var socials=[{'fb':'facebook'},{'twt':'twitter'},{'gp':'google-plus'},{'lkd':'linkedin'},{'mail':'envelope'}]

	var offsetMargin = 0;

	for (var i in socials) {
		var span = $('<span>')
		var s = Object.keys(socials[i])[0]
		var v = socials[i][s]

		span.addClass('btn btn-social-icon shar b btn-' +  v)
		span.attr("social",s)
		span.css({
			"position":"absolute",
			"bottom":0,
			"top": "initial",
			"margin-bottom":"10px",
			"background-color":"transparent",
			"border-color":"#fff",
			"color":"#fff",
			"margin-left":offsetMargin
		})

		var i=$('<i>')
		i.addClass('fa b fa-'+ v)
		i.appendTo(span)

		offsetMargin += 45

	  span.appendTo(parent)
	}
}
