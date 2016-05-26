$(document).on("click","span.shar",function(e){
  e.stopPropagation()
  e.preventDefault()

console.log($(this).closest("a.card-topic"))
  var parent = $(this).closest("a.card-topic")
  var title = parent.find('h4').text()
  var url = parent.attr("share-link")
  var social = $(this).attr("social")
//console.log(title)
//console.log(url)

  if(title==null || title=='' || !title){
    title = 'brNEWS - As principais notícias do Brasil em tempo real. Confira notícias de negócios, tecnologia, política, esporte e economia das melhores fontes do país! Faça seu download já na Google Play.'
  }

  //$('#content2share').data('title',title)
  //$('#content2share').data('url',url)
  //$('#sharemodal').modal().show()

  socialshare(social, title, url, null)
});

function socialshare(social, title, url, desc){
  url = encodeURIComponent(url)
	if(social=='fb'){
		var href = 'https://www.facebook.com/dialog/feed?app_id=723248877786841&display=popup&caption='+title+'&link=http://www.brnews.co/noticia/'+url+'&redirect_uri=http://www.brnews.co/noticia/'+url
		window.open(href,"_system");
	}
	else if(social=='twt'){
		var href = 'https://twitter.com/intent/tweet?url=http://www.brnews.co/noticia/'+url+'&via=brNEWS&related='
		window.open(href,"_system");
	}
	else if(social=='gp'){
		var href= 'https://plus.google.com/share?url=http://www.brnews.co/noticia/'+url+'&title='+title;
		window.open(href,"_system");
	}
	else if(social=='lkd'){
		var href= 'https://www.linkedin.com/shareArticle?mini=true&url=http://www.brnews.co/noticia/'+url+'&title='+title+'&summary=Compartilhamento via brNEWS&source=http://www.brnews.co'
		window.open(href,"_system");
	}else if(social=='mail'){
		var href = 'mailto:?subject=brNEWS - http://www.brnews.co/noticia/'+url+'&body=http://www.brnews.co/noticia/'+url
		window.open(href,"_system");
	}else{
    console.log('ns')
  }
}
