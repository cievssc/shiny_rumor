 #ui home
 
  tabler_tab_item(
         tabName = "home",
          page_heading(title = 'Clipping', pretitle = 'CIEVS', 
                       tags$div( class ="col-auto ms-auto d-print-none",
                          shinyWidgets::dropdown(style = "unite", icon = icon("gear"),  inputId = 'home_dropdown',
                                uiOutput('home_dropopcoes'), left = T))),
       tags$div(class = 'page-body',
        fluidRow(class = 'row row-deck row-cards',
             column(4,
               fluidRow(class = 'row row-deck row-cards',
                  mod_summary_card_ui('home_total', div_class = "col-md-12"),
                  mod_summary_card_ui('home_total_se', div_class = "col-md-12"),
                  #mod_summary_card_ui('home_total_serie', div_class = "col-md-12")
                  mod_summary_card_ui('home_total_fonte', div_class = "col-md-12")
                  )), #end column
             
                  mod_summary_card_ui('home_mapa', div_class = "col-md-8"),
                  mod_summary_card_ui('home_areatecnica', div_class = 'col-md-6'),
                  mod_summary_card_ui('home_doenca', div_class = 'col-md-6'),
                  mod_summary_card_ui('home_notificacao', div_class = 'col-md-4'),
                  mod_summary_card_ui('home_uf', div_class = 'col-md-4'),
                  mod_summary_card_ui('home_fonte', div_class = 'col-md-4'),
                  mod_summary_card_ui('home_tabela1ui', div_class = "col-md-12")
                   
                  )#end row
       
       #verbatimTextOutput('visual')
       ) #end div page-body
       ) #end tabler_tab_item