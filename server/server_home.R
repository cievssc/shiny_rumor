  #server para a aba home (07-fev-2023, 16:18h)
  
   #dados_inicio <- dado
  
  #opções botões dropdown (18-nov-2022,10:24h)
   output$home_dropopcoes <- renderUI(
                               tagList(
                                  selectInput('home_uf', label = h5('UF'),
                                      choices = c('Todos',uf), selected = 'Todos' ,
                                      multiple = T),
                                  selectInput('home_doenca', label = h5('Doenças e agravos'),
                                      choices = c('Todos',agravo), selected = 'Todos' ,
                                      multiple = T),     
                                  selectInput('home_areatec', label = h5('Área técnica'),
                                      choices = c('Todos', area_tec), selected = 'Todos',
                                      multiple = T),    
                                  selectInput('home_notific', label = h5('Notificação imediata?'),
                                      choices = c('Sim', 'Não'), selected = c('Sim', 'Não'),
                                      multiple = T)
                                 #  br(),     
                                # actionButton('home_atualizar', 'Atualizar') 
                                       )      
                                     )
  
  #output head_datas
  
  output$head_datas <- renderUI(
                         dateRangeInput('home_daterange',
                                  label = h5('Período dos registros'),
                                  start = min(inicio$data_noticia, na.rm = T), end = max(inicio$data_noticia, na.rm = T),
                                  separator = " - ", format = "dd/mm/yyyy",
                                  language = 'pt-br'
                                   )       
                                )
 
  #organizando os dados
  #TODO deixar as informações melhor reativas (05-set-2023, 13:40h)
  dados_all <- eventReactive(input$head_atualizar,{
                 dadoi <-  DBI::dbGetQuery(conn(), 'SELECT * FROM rumores_evento')
                 dadoi <- dplyr::left_join(dadoi, centroide, by = c('pais'),na_matches = "never")
                                                                   
                 
                 if(!is.null(input$home_daterange)){
                 dadoi <- subset(dadoi, #(dep_adm %in% input$home_depadm) &
                                      (data_noticia >= as.Date(input$home_daterange[1]) & data_noticia <= as.Date(input$home_daterange[2])))
                }
                     
                  if(nrow(dadoi) == 0){
                  showModal(modalDialog(
                  title = NULL,
                  tagList(
                   p("Não há registros no período.")),
                   easyClose = TRUE,
                   footer = NULL
                   ))
                   NULL
                   }else{
                   dadoi}
                   }, ignoreNULL = F)                            
  
  
   dados_analise <- reactiveVal(0)

   
  
  observeEvent(c( input$head_atualizar),{ #input$home_atualizar,
                     req(!is.null(dados_all()))
                     dadoi <- dados_all()
                     
                     if(input$home_dropdown[1] > 0){
                     if(!any(input$home_uf == 'Todos')){
                        dadoi <- dadoi[(dadoi$uf %in% input$home_uf),]
                        }
                     if(!any(input$home_doenca == 'Todos')){
                        dadoi <- dadoi[(dadoi$doenca %in% input$home_doenca),]
                        }
                     if(!any(input$home_areatec == 'Todos')){
                        dadoi <- dadoi[(dadoi$area_tecnica %in% input$home_areatec),]
                        }   
                    dadoi <- subset(dadoi, notificacao_imed %in% input$home_notific)
                                      }
                                      
                    #if(length(data_of_click$clickedMarker) != 0){  #selecionando as escolas no mapa
                    #    dadoi <- dadoi[dadoi$cod_inep %in% as.numeric(data_of_click$clickedMarker),]
                    #    data_of_click$clickedMarker <- list()
                    #    }  
                    if(nrow(dadoi) == 0){
                  showModal(modalDialog(
                  title = NULL,
                  tagList(
                   p("Não há registros no período.")),
                   easyClose = TRUE,
                   footer = NULL
                   ))
                   NULL
                   }else{
                   dados_analise(dadoi)
                   }     
                          })
  
  #séries temporais dos dados                      
  #serie_falta <- reactive({
   #              dadoi <- dados_analise() 
    #             dadoi$mes_ano <- with(dadoi,factor(mes_ano, levels = unique(mes_ano[order(falta_7)])))
     #             serie <- with(dadoi,as.data.frame(table(mes_ano))  )
      #            serie
       #                 })   
  
  
  
  #========================================================================                      
  #cards
  
  #card total 
  mod_summary_card_server('home_total', 
                            card_large(heading =  'Total de registros no período',
                              uiOutput('home_total_card')%>% withSpinner(color="#0dc5c1")
                             )
                          )
  
  output$home_total_card <- renderUI({
                    dadoi <- dados_analise()
                    dadoi <- nrow(dadoi)
                    tagList(tags$div(class = 'text-center display-5 fw-bold my-3',dadoi)
                    )
                    })
                    
                    
  #total SE
  #TODO adequar as SE para todos os anos
  mod_summary_card_server('home_total_se', 
                            card_large(heading =  'Registros na SE mais recente',
                              uiOutput('home_totalcard_se')%>% withSpinner(color="#0dc5c1")
                             )
                          )
  
  output$home_totalcard_se <- renderUI({
                    dadoi <- dados_analise()
                    dadoi <- dadoi[which(dadoi$se == max(dadoi$se, na.rm = T)),]
                    tagList(tags$div(class = 'text-center display-6 fw-bold my-3',nrow(dadoi))
                    )
                    })
  
  #card total fonte
  mod_summary_card_server('home_total_fonte', 
                            card_large(heading =  'Fonte de notícias mais utilizada',
                              uiOutput('home_total_fonteui')%>% withSpinner(color="#0dc5c1")
                             )
                          )
  
  output$home_total_fonteui <- renderUI({
                    dadoi <- dados_analise()
                    dadoi <- as.data.frame(table(dadoi$fonte))
                    
                    tagList(tags$div(class = 'text-center display-5 fw-bold my-3',dadoi[which.max(dadoi[,2]),1])
                    )
                    })
  
  #============================================================================
  #mapa
  mod_summary_card_server('home_mapa', 
                   card_large(heading = tagList(h1('Mapa')),
                      leafletOutput('home_mapa_leaflet') %>% withSpinner(color="#0dc5c1"))
                             )
                             
                             
  output$home_mapa_leaflet <- renderLeaflet({ home_leaflet_data()
        })
        
  home_leaflet_data <- reactive({
  
   dadoi <- dados_analise()
   
   mapa_dado <- aggregate(country ~ pais + x + y, data = dadoi, FUN = length)     
   mapa_dado$tamanho <- with(mapa_dado, ifelse(country > 10,3, 1))                   
   labells <- function(x){
             mapa_dado <- x
     sprintf(
  "<strong>%s</strong><br/> %s %s" , #  people / mi<sup>2</sup>",
 mapa_dado$pais, 'Qtde Registros: ', mapa_dado$country) %>% lapply(htmltools::HTML)
         }

   leaflet() %>%
        addProviderTiles("OpenStreetMap.Mapnik") %>%
        setView(lat = 0, lng = 0, zoom = 2) %>% clearControls() %>% clearShapes() %>%
        addCircleMarkers(data = mapa_dado, lat = ~y, lng = ~x,
    radius = ~tamanho*5,
    color = '#16DE8C',
    stroke = FALSE, fillOpacity = 0.6,
     weight = 1.5,
    
  label = labells(mapa_dado),
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto"))
                      
  }) #reactive                       
  
                        
 #============================================================================
 #gráficos
 
 #notificação imediata ----------------------------
 mod_summary_card_server('home_notificacao', 
                   tagList(
                     div(class = 'card',
                       div(class = 'card-header',
                           h1(class = 'card-title', 'Notificação imediata?')),
                            div(class = 'body',
                      apexchartOutput('home_notificacao_chart', height = '250px')))
                             ) #end taglist
                             )
 
 output$home_notificacao_chart <- renderApex({
                           dadoi <- dados_analise()
                           dadoi$notificacao_imed <- factor(dadoi$notificacao_imed, levels = c('Sim','Não'))
                           dadoi <- as.data.frame(table(dadoi$notificacao_imed))
                           list(series = c(dadoi$Freq),
                            chart = list(type = 'donut',
                                         height = '100%'),
                            labels = c('Sim', 'Não'),
                            legend = list(position = 'bottom'))
                             
                                     })  #end renderapex                        
                        
                        
 #área técnica
 mod_summary_card_server('home_areatecnica', 
                   tagList(
                     div(class = 'card',
                       div(class = 'card-header',
                           h1(class = 'card-title', 'Área técnica')),
                            div(class = 'body',
                      apexchartOutput('home_areatecnica_chart', height = '250px')))
                             ) #end taglist
                             )
 
 output$home_areatecnica_chart <- renderApex({
                          dadoi <- dados_analise()
                          
                          dadoi <- with(dadoi, as.data.frame(table(area_tecnica)))
                          dadoi <- dplyr::arrange(dadoi, desc(Freq))
 
                           list(series = list(list(data = dadoi[,2])
                                              ),
                                              chart = list(type = 'bar', 
                                                       #toolbar = c(show = FALSE),
                                                       height = '100%'),
                                              #colors = c('#008FFB', '#FF4560'),
                                              dataLabels = c(enabled = FALSE),
                                              plotOptions = list(bar = list(horizontal = T,
                                                                       barheight = '80%')),
                                              xaxis = list(#labels = c(show = FALSE),
                                                      categories =dadoi[,1]
                                                      ),
                                              
                                              grid = list(
                                                          xaxis = list(lines = c(show = FALSE))),
                                              legend = c(show = FALSE)
                                              )
                                     })  #end renderapex                        
                        
  
 #doença
 mod_summary_card_server('home_doenca', 
                   tagList(
                     div(class = 'card',
                       div(class = 'card-header',
                           h1(class = 'card-title', 'Agravos e doenças')),
                            div(class = 'body',
                      apexchartOutput('home_doenca_chart', height = '250px')))
                             ) #end taglist
                             )
 
 output$home_doenca_chart <- renderApex({
                          dadoi <- dados_analise()
                          dadoi <- with(dadoi, as.data.frame(table(doenca)))
                          dadoi <- dplyr::arrange(dadoi, desc(Freq))
                          
                           list(series = list(list(name = 'Doença/Agravo' ,
                                                   data = dadoi[,2])
                                              ),
                                              chart = list(type = 'bar', 
                                                       #toolbar = c(show = FALSE),
                                                       height = '100%'),
                                              #colors = c('#008FFB', '#FF4560'),
                                              dataLabels = c(enabled = FALSE),
                                              plotOptions = list(bar = list(horizontal = T,
                                                                       barheight = '80%')),
                                              xaxis = list(#labels = c(show = FALSE),
                                                      categories =dadoi[,1]
                                                      ),
                                              
                                              grid = list(
                                                          xaxis = list(lines = c(show = FALSE))),
                                              legend = c(show = FALSE)
                                              )
                                     })  #end renderapex 
 
 #uf
 mod_summary_card_server('home_uf', 
                   tagList(
                     div(class = 'card',
                       div(class = 'card-header',
                           h1(class = 'card-title', 'Unidade Federativa')),
                            div(class = 'body',
                      apexchartOutput('home_uf_chart', height = '250px')))
                             ) #end taglist
                             )
 
 output$home_uf_chart <- renderApex({
                          dadoi <- dados_analise()
                          dadoi <- with(dadoi, as.data.frame(table(uf)))
                          dadoi <- dplyr::arrange(dadoi, desc(Freq))
                           list(series = list(list(name = 'UF',
                                                   data = dadoi[,2])
                                              ),
                                              chart = list(type = 'bar', 
                                                       #toolbar = c(show = FALSE),
                                                       height = '100%'),
                                              #colors = c('#008FFB', '#FF4560'),
                                              dataLabels = c(enabled = FALSE),
                                              plotOptions = list(bar = list(horizontal = T,
                                                                       barheight = '80%')),
                                              xaxis = list(#labels = c(show = FALSE),
                                                      categories =dadoi[,1]
                                                      ),
                                              
                                              grid = list(
                                                          xaxis = list(lines = c(show = FALSE))),
                                              legend = c(show = FALSE)
                                              )
                                     })  #end renderapex                                    
 
 
 #fonte (add em 13-mar-2023)
 mod_summary_card_server('home_fonte', 
                   tagList(
                     div(class = 'card',
                       div(class = 'card-header',
                           h1(class = 'card-title', 'Fontes de rumores')),
                            div(class = 'body',
                      apexchartOutput('home_fonte_chart', height = '250px')))
                             ) #end taglist
                             )
 
 output$home_fonte_chart <- renderApex({
                          dadoi <- dados_analise()
                          dadoi <- with(dadoi, as.data.frame(table(fonte)))
                          dadoi <- dplyr::arrange(dadoi, desc(Freq))
                           list(series = list(list(name = 'Fonte',
                                                   data = dadoi[,2])
                                              ),
                                              chart = list(type = 'bar', 
                                                       #toolbar = c(show = FALSE),
                                                       height = '100%'),
                                              #colors = c('#008FFB', '#FF4560'),
                                              dataLabels = c(enabled = FALSE),
                                              plotOptions = list(bar = list(horizontal = T,
                                                                       barheight = '80%')),
                                              xaxis = list(#labels = c(show = FALSE),
                                                      categories =dadoi[,1]
                                                      ),
                                              
                                              grid = list(
                                                          xaxis = list(lines = c(show = FALSE))),
                                              legend = c(show = FALSE)
                                              )
                                     })  #end renderapex  
 
 #==========================================
 #tabelas
 mod_summary_card_server('home_tabela1ui',
                      tags$div(class = 'card',
                    tags$div(class = 'card-header',
                    h1('Tabela')),
                    tags$div(class = 'card-body',
                    #tableOutput('home_tabela1')
                    reactableOutput('home_tabela1')
                    ),
                    tags$div(class = 'card-footer',
                       tags$div(class = "ms-auto lh-1",
                          downloadButton('download_tabela1', 'Baixar')      )       
                             )) #end divs     
                    )  
  
                   
  output$home_tabela1 <- renderReactable({ #renderText({  #DT::renderDataTable({#
                           dadoi <- dados_analise()
                           dadoi <- dadoi[,c(2,1,3,7,5,8,9,10)]
                           names(dadoi) <- c('Id','SE','Data notícia','Doença/Agravo','Descrição','Notificação\nImediata?','Área técnica','Fonte')
                           reactable(dadoi,searchable = TRUE)
                           #kbl(dadoi) %>%
                           #kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
                           #scroll_box(width = "100%", height = "480px")
                            }) 
 
 output$download_tabela1 <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(dados_analise()[,c(2,1,3,7,5,8,9,10)], file)
    }
  ) 