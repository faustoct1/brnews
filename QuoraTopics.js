/**
 * Run this script for extract Quora's topic of http://www.quora.com/sitemap
 * Can be run form node.js or browser.
 */
var sitemap=$("div.col > dl");
var json={};
for(var i=0;i<sitemap.length;i++){
	var inside = $(sitemap[i]).find("dt");
	for(var j=0;j<inside.length;j++){
		var topic=$(inside[j]).text();
		json[topic]=[];
		console.log(topic);
		var contents = $(sitemap[i]).find("dd");
		for(var k=0;k<contents.length;k++){
			var content =  $(contents[k]).text();
			json[topic].push(content);
			console.log(content);
		}
	}
}
delete json['Social Media']; //remove social media content  
console.log(JSON.stringify(json));

