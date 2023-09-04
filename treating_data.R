 #cod6 para o mapa
 municipiopoly$cod6 <- floor(as.numeric(municipiopoly$CD_GEOCMU)/10)
 
 #categorias uf
 uf <- unique(dado$uf)
 agravo <- unique(dado$doenca)
 area_tec <- unique(dado$area_tecnica)
 