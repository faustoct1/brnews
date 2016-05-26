task :yuicompress do #=> :environment 
  puts "Compressing CSS"
  %x( java -jar utils/yuicompressor-2.4.8.jar public/css/basic.css -o public/css/basic-min.css --charset utf-8 )
  %x( java -jar utils/yuicompressor-2.4.8.jar public/css/hacks.css -o public/css/hacks-min.css --charset utf-8 )
  %x( java -jar utils/yuicompressor-2.4.8.jar public/css/home.css -o public/css/home-min.css --charset utf-8 )
  %x( java -jar utils/yuicompressor-2.4.8.jar public/css/landing.css -o public/css/landing-min.css --charset utf-8 )
  %x( java -jar utils/yuicompressor-2.4.8.jar public/css/settings.css -o public/css/settings-min.css --charset utf-8 )
  %x( java -jar utils/yuicompressor-2.4.8.jar public/css/style.css -o public/css/style-min.css --charset utf-8 )
  
  puts "Compressing JS"
  %x( java -jar utils/yuicompressor-2.4.8.jar public/js/FeedFactory.js -o public/js/FeedFactory-min.js --charset utf-8 )
  %x( java -jar utils/yuicompressor-2.4.8.jar public/js/home.js -o public/js/home-min.js --charset utf-8 )
  %x( java -jar utils/yuicompressor-2.4.8.jar public/js/time.js -o public/js/time-min.js --charset utf-8 )
end
