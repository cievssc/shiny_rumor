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

 #---------------------------------------------------------------------------
 #nuvem de palavras (14-set-2023, 16:17h)

 # Função para normalizar texto
NormalizaParaTextMining <- function(texto){
 
  # Normaliza texto
  texto %>% 
    chartr(
      old = "áéíóúÁÉÍÓÚýÝàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛãõÃÕñÑäëïöüÄËÏÖÜÿçÇ´`^~¨:.!?&$@#0123456789",
      new = "aeiouAEIOUyYaeiouAEIOUaeiouAEIOUaoAOnNaeiouAEIOUycC                       ",
      x = .) %>% # Elimina acentos e caracteres desnecessarios
    str_squish() %>% # Elimina espacos excedentes 
    tolower() %>% # Converte para minusculo
    return() # Retorno da funcao
}

# Lista de palavras para remover
palavrasRemover <- c(stopwords(kind = "pt"), letters) %>%
  as.tibble() %>% 
  rename(Palavra = value) %>% 
  mutate(Palavra = NormalizaParaTextMining(Palavra))

palavrasRemover_ii <-  c(stopwords::stopwords("pt",'stopwords-iso')) %>%
  as.tibble() %>% 
  rename(Palavra = value) %>% 
  mutate(Palavra = NormalizaParaTextMining(Palavra))
 
 