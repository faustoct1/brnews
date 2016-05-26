#require 'bundle/bundler/setup'

require 'padrino-core'
require 'active_record'
require 'json'
require 'rss'
require 'open-uri'

puts "start"

["./config/database", "./models/story","./models/source","./models/topic","./models/source_topic","./models/user_topic", "./models/source_miss"].each do |file|
  puts "Loading #{file}"
  require file
end

class GrabException < Exception
end

sources = {
  economy:[],
  politics:[],
  sport:[],
  tech:[],
  business:[]
}

url = 'https://www.ruby-lang.org/en/feeds/news.rss'
open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  puts "Title: #{feed.channel.title}"
  feed.items.each do |item|
    puts "Item: #{item.title}"
  end
end

=begin
http://topicos.estadao.com.br/rss
http://topicos.estadao.com.br/
www.estadao.com.br
politica
economia
pme
esporte
link

http://www1.folha.uol.com.br/tec/2013/01/740140-confira-lista-de-feeds-do-site-da-folha.shtml
www.folha.uol.com.br
esporte
poder
tec

http://rss.uol.com.br/indice.html
www.uol.com.br
esporte
gizmodo
olhardigital

http://g1.globo.com/tecnologia/noticia/2012/11/siga-o-g1-por-rss.html
g1 globo

http://www.r7.com/institucional/rss/#
www.r7.com
esporte
economia
tecnologia-e-ciencia

http://www.ig.com.br/rss/
www.ig.com.br
economia
esporte

http://exame.abril.com.br/rss/
exame.abril.com.br
tecnologia
economia
negocios
pme

http://www.istoe.com.br/servicos/rss/
www.istoe.com.br

www.terra.com.br
moda
esporte

http://editoraglobo.globo.com/rss/
globo

veja.abril.com.br
economia
noticia
vida-digital
esporte

http://globoesporte.globo.com/Esportes/0,,GEH946-9645,00.html
globoesporte.globo.com

info.abril.com.br
http://info.abril.com.br/rss/

www.tecmundo.com.br
http://www.tecmundo.com.br/rss

http://techtudo3.webnode.com/rss/
www.techtudo.com.br

canaltech.com.br
http://canaltech.com.br/rss/

idgnow.com.br
http://idgnow.com.br/rss

www.valor.com.br
http://www.valor.com.br/pagina/rss


1 | Blank       |             |            | 2015-04-20 17:38:10.116775 | 2015-04-20 17:38:10.116775
2 | Politics    | Politics    | Política   | 2015-04-20 17:38:11.723677 | 2015-04-20 17:38:11.723677
3 | Economy     | Economy     | Economia   | 2015-04-20 17:38:12.749834 | 2015-04-20 17:38:12.749834
4 | Sports      | Sports      | Esporte    | 2015-04-20 17:38:13.771241 | 2015-04-20 17:38:13.771241
5 | Technology  | Technology  | Tecnologia | 2015-04-20 17:38:14.77066  | 2015-04-20 17:38:14.77066
6 | Business    | Business    | Negócio    | 2015-04-20 17:38:16.037892 | 2015-04-20 17:38:16.037892
7 | Environment | Environment | Ambiente   | 2015-04-20 17:38:16.831831 | 2015-04-20 17:38:16.831831
8 | Culture     | Culture     | Cultura    | 2015-04-20 17:38:18.014698 | 2015-04-20 17:38:18.014698
9 | Education   | Education   | Educação   | 2015-04-20 17:38:19.035208 | 2015-04-20 17:38:19.035208
10 | Music       | Music       | Música     | 2015-04-20 17:38:19.692905 | 2015-04-20 17:38:19.692905
11 | Fashion     | Fashion     | Moda       | 2015-04-20 17:38:21.034869 | 2015-04-20 17:38:21.034869
(11 rows)
=end
