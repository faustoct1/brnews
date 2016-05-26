# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#
#email     = shell.ask "Which email do you want use for logging into admin?"
#password  = shell.ask "Tell me the password to use:"
email = "contact@XXX.com"
password = ""

shell.say ""

account = Account.create(:email => email, :name => "", :surname => "", :password => password, :password_confirmation => password, :role => "admin")

if account.valid?
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email: #{email}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went wrong!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""

Topic.create(name: 'Blank', us: '', pt: '') #use this if you do know how to classify!
Topic.create(name: 'Politics', us: 'Politics', pt: 'Política')
Topic.create(name: 'Economy', us: 'Economy', pt: 'Economia')
Topic.create(name: 'Sports', us: 'Sports', pt: 'Esporte')
Topic.create(name: 'Technology', us: 'Technology', pt: 'Tecnologia')
Topic.create(name: 'Business', us: 'Business', pt: 'Negócio')
Topic.create(name: 'Environment', us: 'Environment', pt: 'Ambiente')
Topic.create(name: 'Culture', us: 'Culture', pt: 'Cultura')
Topic.create(name: 'Education', us: 'Education', pt: 'Educação')
Topic.create(name: 'Music', us: 'Music', pt: 'Música')
Topic.create(name: 'Fashion', us: 'Fashion', pt: 'Moda')

#maybe for websites something link
#type: parent
#type: children
#parent: nil
#parent: estadao.com.br, estadao, or something

source_topics_pt=[
  {
    fb_id: 115987058416365,
    fb_page: 'estadao',
    website: 'www.estadao.com.br',
    name: 'Estadão',
    topics: [:politics, :economy, :sports, :technology, :business]
  },
  {
    website:'politica.estadao.com.br',
    fb_id: 161271387271153,
    fb_page: 'politicaestadao',
    name: 'Estadão',
    topics: [:politics]
  },
  {
    website:'economia.estadao.com.br',
    fb_id: 123288521042765,
    fb_page: 'economiaestadao',
    name: 'Estadão',
    topics: [:economy]
  },
  {
    website:'blogs.pme.estadao.com.br',
    fb_id: 194083550639665,
    fb_page: 'estadaopme',
    name: 'Estadão',
    topics: [:business]
  },
  {
    fb_page: 'folhadesp',
    website:'www.folha.uol.com.br',
    fb_id:100114543363891,
    name: 'Folha de S.Paulo',
    topics: [:politics, :economy, :sports, :technology, :business]
  },
  {
    website: 'www.terra.com.br',
    fb_id:136852373848,
    fb_page:'TerraBrasil',
    name: 'TerraBrasil',
    topics: [:politics, :economy, :sports, :technology, :business]
  },
  {
    website: 'moda.terra.com.br',
    name: 'Terra',
    topics: [:fashion]
  },
  {
    website: 'esportes.terra.com.br',
    name: 'Terra',
    topics: [:sports]
  },
  {
    website: 'www.istoe.com.br',
    fb_page: 'revistaISTOE',
    fb_id:142656675745901,
    name: 'Revista ISTOÉ',
    topics: [:politics, :economy, :technology, :business]
  },
  {
    website: 'g1.globo.com',
    fb_page:'g1',
    fb_id:'180562885329138',
    name: 'G1 - O Portal de Notícias da Globo',
    topics: [:politics, :economy, :sports, :technology, :business]
  },
  {
    website: 'g1.globo.com/globo-news',
    fb_page:'GloboNews',
    fb_id:200292646669956,
    name: 'Globo News',
    topics: [:politics, :economy]
  },
  {
    website: 'oglobo.globo.com',
    fb_page: 'jornaloglobo',
    fb_id:115230991849922,
    name: 'O Globo',
    topics: [:politics, :economy, :sports, :technology, :business]
  },
  {
    website: 'oglobo.globo.com/economia',
    name: 'O Globo',
    topics: [:economy]
  },
  {
    website: 'oglobo.globo.com/esportes',
    name: 'O Globo',
    topics: [:sports]
  },
  {
    website: 'oglobo.globo.com/sociedade/tecnologia',
    name: 'O Globo',
    topics: [:technology]
  },
  {
    website: 'veja.abril.com.br',
    fb_page:'Veja',
    fb_id:109597815616,
    name: 'VEJA',
    topics: [:politics, :economy]
  },
  {
    website: 'veja.abril.com.br/noticia/economia',
    name: 'VEJA',
    topics: [:economy]
  },
  {
    website: 'veja.abril.com.br/vida-digital',
    name: 'VEJA',
    topics: [:technology]
  },
  {
    fb_page: 'vejaesportes',
    fb_id: 472834066100482,
    website: 'veja.abril.com.br/noticia/esporte',
    name: 'VEJA',
    topics: [:sports]
  },
  {
    website: 'www.bbc.co.uk/portuguese',
    fb_page:'bbcbrasil',
    fb_id:303522857815,
    name: 'BBC Brasil',
    topics: [:politics, :economy]
  },
  {
    website: 'www.bbc.co.uk/portuguese/topicos/economia',
    name: 'BBC Brasil',
    topics: [:economy]
  },
  {
    website: 'www.bbc.co.uk/portuguese/topicos/ciencia_e_tecnologia',
    name: 'BBC Brasil',
    topics: [:technology]
  },
  {
    website: 'www.r7.com',
    fb_page: 'portalr7',
    fb_id:142404191637,
    name: 'Portal R7',
    topics: [:politics, :economy, :sports, :technology, :business]
  },
  {
    website: 'esportes.r7.com',
    name: 'Portal R7',
    topics: [:sports]
  },
  {
    website: 'noticias.r7.com/economia',
    name: 'Portal R7',
    topics: [:economy]
  },
  {
    website: 'noticias.r7.com/tecnologia-e-ciencia',
    name: 'Portal R7',
    topics: [:techonolgy]
  },
  {
    website: 'www.ig.com.br',
    fb_page: 'ig',
    fb_id:128293387213762,
    name: 'iG',
    topics: [:politics, :economy, :sports, :technology, :business]
  },
  {
    website: 'economia.ig.com.br',
    name: 'iG',
    topics: [:economy]
  },
  {
    website: 'esporte.ig.com.br',
    fb_page: 'igesporte',
    fb_id: 177021808976207,
    name: 'iG',
    topics: [:sports]
  },
  {
    website: 'www.jb.com.br',
    fb_page: 'JornaldoBrasil.JB',
    fb_id:155148484507606,
    name: 'Jornal do Brasil',
    topics: [:politics, :economy]
  },
  {
    website: 'www.jb.com.br/ciencia-e-tecnologia',
    name: 'Jornal do Brasil',
    topics: [:technology]
  },
  {
    website: 'www.jb.com.br/economia',
    name: 'Jornal do Brasil',
    topics: [:technology]
  },
  {
    website: 'www.jb.com.br/esportes',
    name: 'Jornal do Brasil',
    topics: [:sports]
  },
  {
    website: 'exame.abril.com.br',
    fb_page:'Exame',
    fb_id:131180673952,
    name: 'Exame',
    topics: [:politics, :economy, :technology, :business]
  },
  {
    website: 'exame.abril.com.br/tecnologia',
    name: 'Exame',
    topics: [:technology]
  },
  {
    website: 'exame.abril.com.br/economia',
    name: 'Exame',
    topics: [:economy]
  },
  {
    website: 'exame.abril.com.br/negocios',
    name: 'Exame',
    fb_page: 'examepme',
    fb_id: 169014276488298,
    topics: [:business]
  },
  {
    website: 'exame.abril.com.br/pme',
    fb_page: 'ExamePMESouEmpreendedor',
    fb_id: '392703200827467',
    name: 'Exame',
    topics: [:business]
  },
  {
    website: 'esporte.uol.com.br',
    fb_page:'UOLEsporte',
    fb_id:115401215190141,
    name: 'UOL',
    topics: [:sports]
  },
  {
    website: 'esporteinterativo.com.br',
    fb_page:'esporteinterativo',
    fb_id:135158248503,
    name: 'Esporte Interativo',
    topics: [:sports]
  },
  {
    website: 'esportes.estadao.com.br',
    fb_id:369313899800134,
    fb_page:'estadaoesporte',
    name: 'Estadão',
    topics: [:sports]
  },
  {
    website: 'globoesporte.globo.com',
    fb_page: 'Globoesportecom',
    fb_id: 22344895408,
    name: 'Globo',
    topics: [:sports]
  },
  {
    website: 'www1.folha.uol.com.br/esporte',
    fb_page: 'FolhaEsporte',
    fb_id:230454357001527,
    name: 'Folha',
    topics: [:sports]
  },
  {
    website: 'www1.folha.uol.com.br/poder',
    fb_page: 'folhapoder',
    fb_id:109104542461312,
    name: 'Folha',
    topics: [:politics]
  },
  {
    website: 'www1.folha.uol.com.br/tec',
    fb_page: 'folhatec',
    fb_id: 187317651315800,
    name: 'Folha',
    topics: [:technology]
  },
  {
    website: 'olhardigital.uol.com.br',
    fb_page: 'olhardigital',
    fb_id:135284343149190,
    name: 'Olhar Digital',
    topics: [:technology]
  },
  {
    website: 'info.abril.com.br',
    fb_page: 'revistainfo',
    fb_id:111095503629,
    name: 'INFO',
    topics: [:technology]
  },
  {
    website: 'www.tecmundo.com.br',
    fb_page: 'tecmundo',
    fb_id:111090485635468,
    name: 'TecMundo',
    topics: [:technology]
  },
  {
    website: 'www.techtudo.com.br',
    fb_page: 'techtudo',
    fb_id:159328784089544,
    name: 'TechTudo',
    topics: [:technology]
  },
  {
    website: 'gizmodo.uol.com.br',
    fb_page: 'gizmodobrasil',
    fb_id:136501013055080,
    name: 'Gizmodo Brasil',
    topics: [:technology]
  },
  {
    website: 'canaltech.com.br',
    fb_page: 'canaltech',
    fb_id:264439246937821,
    name: 'Canaltech',
    topics: [:technology]
  },
  {
    website: 'idgnow.com.br',
    fb_id:23027913857,
    fb_page:'idgnow',
    name: 'IDG Now!',
    topics: [:technology]
  },
  {
    website: 'blogs.estadao.com.br/link',
    fb_page: 'linkestadao',
    fb_id:112536122105936,
    name: "Estadão",
    topics: [:technology]
  },
  {
    website: 'www.valor.com.br',
    fb_page: 'valoreconomico',
    fb_id: 197587446941661,
    name: "Valor Economico",
    topics: [:economy, :politics]
  },
  {
    website: 'www.valor.com.br/politica',
    name: "Valor Economico",
    topics: [:politics]
  },
  {
    website: 'www.valor.com.br/financas',
    name: "Valor Economico",
    topics: [:economy]
  },
]

source_topics_pt.each do |source|
  s=Source.create(website: source[:website], fb_page: source[:fb_page], fb_id: source[:fb_id], name: source[:name].to_s, language:'pt')
  source[:topics].each do |topic|
    t = Topic.where(name: topic.capitalize.to_s).first
    s.source_topics << SourceTopic.new({topic: t})
  end
end


#FIXME MAKE LINKS AND HASH TAGS CLICKABLE!
#Topics size 4: 142656675745901 - http://bit.ly/1CPvyrW - www.istoe.com.br
#http://g1.globo.com/sp/sao-carlos-regiao/noticia/2015/04/ele-o-jogo-do-brasil-enquanto-meu-filho-morria-afirma-pai-sobre-medico-santa-casa-sao-carlos-noah.html?utm_source=facebook&utm_medium=social&utm_campaign=g1
#http://www.istoe.com.br/assuntos/semana/detalhe/414127_
#http://saude.ig.com.br/minhasaude/2015-04-16/atitudes-que-causam-corrimento-vaginal.html - saude.ig.com.br/minhasaude/2015-04-16/atitudes-que-causam-corrimento-vaginal.html
#http://igay.ig.com.br/2015-04-16/relatora-da-lei-maria-da-penha-propoe-primeira-alteracao-incluir-mulheres-trans.html - igay.ig.com.br/2015-04-16/relatora-da-lei-maria-da-penha-propoe-primeira-alteracao-incluir-mulheres-trans.html
#http://noticias.r7.com/tecnologia-e-ciencia/fotos/quase-um-emoticon-nasa-captura-foto-de-galaxia-sorrindo-16042015#!/foto/1
#http://www.bbc.co.uk/portuguese/noticias/2015/04/150416_galeria_quartos_sewol_rb?ocid=socialflow_facebook
#http://carros.ig.com.br/lancamentos/jac+t6+tem+porte+de+medio+e+preco+de+compacto/8801.html
#veja.abril.com.br/noticia/mundo/video-guarda-do-palacio-de-buckingham-leva-um-tombo-durante-troca-de-turnos
#http://oglobo.globo.com/cultura/revista-da-tv/ainda-nao-fiquei-com-ninguem-fora-da-casa-garante-ex-bbb-fernando-que-diz-ja-ter-se-entendido-com-amanda-pela-midia-15898320?utm_source=Facebook&utm_medium=Social&utm_campaign=O%20Globo
#www.facebook.com/GloboNews/videos/958432130856000/
#http://g1.globo.com/ceara/noticia/2015/04/veneno-que-matou-crianca-no-ce-foi-dado-pela-mae-em-sorvete-diz-policia.html?utm_source=facebook&utm_medium=social&utm_campaign=g1
#http://g1.globo.com/tecnologia/noticia/2015/04/mais-lidas-do-dia-16abril2015.html?utm_source=facebook&utm_medium=social&utm_campaign=g1
#http://www.istoe.com.br/reportagens/414343_PRESIDENTE+DO+BNDES+DIZ+QUE+O+BANCO+PODE+REVER+O+FINANCIAMENTO+DE+PROJETOS+DA+PETROBRAS+EM+ANDAMENTO?pathImagens=&path=&actualArea=internalPage
#http://noticias.terra.com.br/brasil/cidades/estudante-confecciona-notas-falsas-no-interior-de-pernambuco,184d83c03c3cc410VgnVCM5000009ccceb0aRCRD.html - noticias.terra.com.br/brasil/cidades/estudante-confecciona-notas-falsas-no-interior-de-pernambuco,184d83c03c3cc410VgnVCM5000009ccceb0aRCRD.html
#http://veja.abril.com.br/noticia/saude/seis-maneiras-de-economizar-na-compra-de-remedios - veja.abril.com.br/noticia/saude/seis-maneiras-de-economizar-na-compra-de-remedios
#http://www1.folha.uol.com.br/ilustrada/2015/04/1617605-nao-vamos-agradar-todo-mundo-diz-diretor-jj-abrams-sobre-star-wars.shtml?cmpid=facefolha

#business entrepreunership:
#sebrae
#startup brasil
#ABF
#associacao brasileira de startups
#startup farm
#circuito startup
#Finep inovacao e pesquisa
#Geracao de Valor
#Endeavor Brasil
#Techcrunch
#SUCCESS Magazine
#The next web
#Startupvitamins
#TED
#Mahsable
#Inc
#Entrepreuner

#curiosidades
#geral
#noticias
#ultima hora
#mundo

#ciencia
#educacao
#ambiente
#mundo
#saude
#brasil/cidade

#TODO:
#mvp
#think about how to GRAB, CLASSIFY AND CRAWL CONTENT AUTOMATICALLY
#add search fb auto
#think in a complete mvp. users. community. whaT??. model the product. concept abstraction.
#conceptual modeling

#share at the same time in different socials
