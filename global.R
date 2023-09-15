 #carregando os pacotes...
 library('shiny')
 library('shinydashboard')
 library('shinydashboardPlus')
 library('shinyWidgets')
 #library('plotly')
 library('leaflet')
 library('leaflet.extras')
 #library('leaflet.extras2')
 #library('bs4Dash')
 library('htmltools')
 library('shinycssloaders') #add em 18-nov-2022(14:07h)

 library('dplyr')        #manipulação de dados - tydiverse
 library('stringr')      #funções de string  - tydiverse
 library('rgeos') #leitura de mapas
 library('rgdal') #leitra de mapas
 library('sf') #plot maps
 library('magrittr')     #para mudar nome de colunas
 library('reshape2')
 library('data.table')
 library('RColorBrewer')
 #library('scales')
 library('raster')
 #library('xts')
 #library('dygraphs')
 #library('highcharter')
 #library('ggplot2')
 #library('formattable') #tabelas personalizadas
 library('reactable')
 library('wordcloud2') #nuvem de palavras (add 14-set-2023)
 library('tm') #funções para contagem de palavras
 library('tidytext') #organizar textos

 #para predições
# library('forecast')
 
 #tabelas
 library('kableExtra')

 #carregand dados
 
 load('municipios_br.RData')
 load('municipiopoly.RData')
 load('centroide.RData')
 #dados iniciais
 #load('dado_dash.RData')

 
 
 source('./treating_data.R', local = T, encoding = 'UTF-8')
 options(warn = -1)
 
 #apexcharts
 source('./www/apexchart/general_apex.R')
 
 #plotly
 source('./www/highcharts/generalhigh.R')
 source('./www/highcharts/plotlyjs.R')
 
 #carregando funçes dashboard
 source('./www/tablerdash/funcoes_dashboard.R')
 source('./www/tablerdash/cards.R')
 source('./www/tablerdash/icons.R')

