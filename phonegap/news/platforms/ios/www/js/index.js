/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        //document.addEventListener("resume", this.onResume, false);
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
      var info= checkConnection()
      if(info[1]){
        try{
          console.log(1)
          setupEverything()
        }catch(e){console.log(e.message);}
        //window.location = "http://brnews.4linked.com?app=true";
      }else{
        var msg = "Esse aplicativo requer conexão com a internet. A conexão é muito lenta ou não foi detectada para esse dispositivo. Tipo de conexão: " + info[0] + "."
        $('#error').text(msg)
        $('#error').removeClass('hide')
        //alert(msg);
      }

      //$("div.navbar-static-top").autoHidingNavbar();

      //loadsummary()

      try{
        adSetup()
      }catch(e){alert('error to setup ad');/*here is better post a message when get some error!*/}

      try{
        window.analytics.startTrackerWithId('UA-65575834-1')
        window.analytics.trackView('Feed')
      }catch(e){alert('error to setup analytics');/*here is better post a message when get some error!*/}
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
    }
};

function settings(data, callback){
  var url = 'http://brnews.herokuapp.com/app'

  if(data){
    url = (url + '?payload='+data.notify + ',' + data.registrationId + ',' + data.type)
  }

  $.get(url,function(resp){
    var json = JSON.parse(resp)
    var topics = json.topics.split(',')
    for (var i=0;i<topics.length;i++){
      $('input#'+topics[i]).attr('checked','')
    }
    $(".topic-switch").bootstrapSwitch()
    callback()
  })

  var options = []
  $('a.back').click(function(e){
    e.preventDefault()
    e.stopPropagation()

    var opts = [];
    $("input:checked").each(function(){
      opts.push($(this).attr('id'))
    })

    if(opts.length>0){
      $.get('http://brnews.herokuapp.com/app',{topics: opts.toString()},function(res){
        window.location="index.html"
        waitingDialog.hide()
      });
      waitingDialog.show('Criando seu Feed de Notícias', {dialogSize: 'sm'});
    }else{
      alert('Selecione pelo menos 1 tópico')
    }
  })
}

function setupEverything(){
  if(window.location.pathname.indexOf('summary.html')!=-1){
    $.get('http://brnews.herokuapp.com/dailydigest',function(res){
      var factory = new FeedFactory()
      var json = JSON.parse(res)

      if(json.data.morning && json.data.morning.length>0){
          $('#morning').removeClass('hidden')
          factory.append(json.data.morning,"#morning")
      }

      if(json.data.afternoon && json.data.afternoon.length>0){
          $('#afternoon').removeClass('hidden')
          factory.append(json.data.afternoon,"#afternoon")
      }
    })
  }else{
    pushNotification(true,function(data){
      settings(data, function(){angular.bootstrap(document,['home']);})
    });
  }
}

function pushNotification(enable, callback){

  try{
    if(enable){
      var push = null
      var push = PushNotification.init({
          android: {
              senderID: "696546624447"
          },
          ios: {
              alert: "true",
              badge: true,
              sound: 'false'
          },
          windows: {}
      });

      push.on('registration', function(data){
        callback({ notify: true, registrationId: data.registrationId, type: 'add'})
      });

      push.on('notification', function(data) {
        if(data.additionalData.foreground==true && data.additionalData.coldstart==undefined){
          $('#summary').removeClass('hidden')
        }else if (data.additionalData.foreground==false && data.additionalData.coldstart==false){
          //app already launch and it's in background
          window.location="summary.html"
        }else if (data.additionalData.foreground==false && data.additionalData.coldstart==true){
          //app is closed and i clicked on the push notification
          window.location="summary.html"
        }
        //alert(data.additionalData.foreground + " - " + data.additionalData.coldstart)
        //window.localStorage.view = "summary.html"
      });

      push.on('error', function(e){
        alert(e)
      });

      return push
    }else{
      callback({ notify: true, registrationId: "dev", type: 'add'})
    }
  }catch(e){
    console.log(e)
  }
}

/*function loadsummary(){
  $.get('http://brnews.herokuapp.com/summary',function(d){
    var stories = JSON.parse(d)['stories']

    for(var i=0;i<stories.length;i++){
      var f = stories[i]

      var row = $("<div class='row'>");
      row.attr("id","_f"+i);

      var root = $("<div>");
      root.addClass("col-xs-12 col-sm-9 col-md-6 col-lg-5 col-md-offset-2 col-lg-offset-3 col-sm-offset-2 clearfix lrg");
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

      //var hrefId = f.uid_url + f.published;
      var subject = $("<h5>");
      var ssubject = $("<strong>")
      subject.addClass('list-group-item-text')
      ssubject.text(f.topicn)
      ssubject.appendTo(subject)
      subject.appendTo(_overlay)

      var title = $("<h4>");
      title.addClass('list-group-item-text')
      var _text = (f.title ? f.title : (f.fb_message ? f.fb_message : ""))
      _text = _text.substring(0,100) + ((_text.length>100) ? '...' : '')
      title.text(_text)
      title.appendTo(_overlay)

      var who = $("<h6>");
      who.addClass('list-group-item-text')
      who.appendTo(_overlay)

      who.text(f.fb_from_name + " há " + when(f.published))

      row.appendTo($("#highlights"));
    }
  });
}*/

function adSetup(){
  var admobid = {};
  if( /(android)/i.test(navigator.userAgent) ) {
      admobid = { // for Android
          banner: 'ca-app-pub-2932594016137124/1802206899',
          interstitial: ''
      };
  } else if(/(ipod|iphone|ipad)/i.test(navigator.userAgent)) {
      admobid = { // for iOS
          banner: '',
          interstitial: ''
      };
  } else {
      admobid = { // for Windows Phone
          banner: '',
          interstitial: ''
      };
  }

  if (AdMob) {
    AdMob.createBanner({
        adId : admobid.banner,
        position : AdMob.AD_POSITION.BOTTOM_CENTER,
        autoShow : true
    });
  }
}

$(document).on('click','a.card-topic',function(e){
  //http://css-tricks.com/NetMag/FluidWidthVideo/Article-FluidWidthVideo.php
  e.preventDefault();
  e.stopPropagation();

  var href=$(this).attr("href").replace(/&.*$/,"");
  window.location.href=href
  //window.open(href,"_system");
  //window.open(href);
  /*if(app){
    window.open(href,"_system");
  }
  else{
    window.open(href,"_blank");
  }*/
});

/*$(document).on("taphold","a.newsclick",function(event){
  var title = $(this).find('h4').text()
  var url = $(this).attr("share-link")

  if(title==null || title=='' || !title){
    title = 'brNEWS - As principais notícias do Brasil em tempo real. Confira notícias de negócios, tecnologia, política, esporte e economia das melhores fontes do país! Faça seu download já na Google Play.'
  }

  $('#content2share').data('title',title)
  $('#content2share').data('url',url)
  $('#sharemodal').modal().show()
});*/

function checkConnection() {
  return [true,true]
  var networkState = navigator.connection.type;
  var Connection = navigator.connection;
  var states = {};
  states[Connection.NONE]     = ['No network connection',false];
  states[Connection.CELL_2G]  = ['Cell 2G connection',false];
  states[Connection.ETHERNET] = ['Ethernet connection', true];
  states[Connection.WIFI]     = ['WiFi connection',true];
  states[Connection.CELL_3G]  = ['Cell 3G connection',true];
  states[Connection.CELL_4G]  = ['Cell 4G connection',true];
  states[Connection.UNKNOWN]  = ['Unknown connection',true];
  states[Connection.CELL]     = ['Cell generic connection',true];
  return states[networkState]
}

app.initialize();
