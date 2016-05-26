when = function(t) {
    var now = new Date().getTime();
    //fix date to time_ago => http://stackoverflow.com/questions/2782976/convert-facebook-date-format-to-javascript-date
    var previous = new Date(t*1000).getTime();

    //FIXME GET FROM SERVER OR INTERNET. THE TIME CAN COME FROM NON UPDATE ENVIRONMENT!!!
    if(now < previous)return "";

    /*
    var iOS = /(iPad|iPhone|iPod)/g.test( navigator.userAgent );
    var iOS = false,
        p = navigator.platform;

    if( p === 'iPad' || p === 'iPhone' || p === 'iPod' ){
        iOS = true;
    }*/

    var msPerMinute = 60 * 1000;
    var msPerHour = msPerMinute * 60;
    var msPerDay = msPerHour * 24;
    var msPerMonth = msPerDay * 30;
    var msPerYear = msPerDay * 365;

    var elapsed = now - previous;

    if (elapsed < msPerMinute) {
      return Math.round(elapsed/1000) + 'min';
    }

    else if (elapsed < msPerHour) {
      return Math.round(elapsed/msPerMinute) + 'min';
    }

    else if (elapsed < msPerDay ) {
      return Math.round(elapsed/msPerHour ) + 'h';
    }

    else if (elapsed < msPerMonth) {
      // return 'approximately ' + Math.round(elapsed/msPerDay) + ' days ago';
      return Math.round(elapsed/msPerDay) + 'd';
    }

    else if (elapsed < msPerYear) {
      // return 'approximately ' + Math.round(elapsed/msPerMonth) + ' months ago';
      return Math.round(elapsed/msPerMonth) + 'meses';
    }

    else {
      // return 'approximately ' + Math.round(elapsed/msPerYear ) + ' years ago';
      return Math.round(elapsed/msPerYear ) + 'anos';
    }

    throw "time conversion error";
}
