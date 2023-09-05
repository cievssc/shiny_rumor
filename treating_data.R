 #carregando dados
 conn <- function(){DBI::dbConnect(RPostgres::Postgres(),  host = '172.22.34.56', port = 5432, user = 'dimitri',
                     password = 'cievs666', dbname = 'rumores')} 
 
 inicio <- DBI::dbGetQuery(conn(), 'SELECT * FROM rumores_evento')
 
 #cod6 para o mapa
 municipiopoly$cod6 <- floor(as.numeric(municipiopoly$CD_GEOCMU)/10)
 
 #categorias uf
 uf <- unique(inicio$uf)
 agravo <- unique(inicio$doenca)
 area_tec <- unique(inicio$area_tecnica)

 rm(inicio)
 