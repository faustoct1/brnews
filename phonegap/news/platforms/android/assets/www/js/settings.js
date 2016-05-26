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
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
      $.get('http://brnews.herokuapp.com/app',function(resp){
        var json = JSON.parse(resp)
        var topics = json.topics.split(',')
        for (var i=0;i<topics.length;i++){
          $('input#'+topics[i]).attr('checked','')
        }
        $(".topic-switch").bootstrapSwitch()
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

function checkConnection() {
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
