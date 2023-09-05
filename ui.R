 #app 
 ui <-  tabler_page(dark = F,
   header_tabler(logo = HTML('<img src="./images/cievs_nacional.png" width="332px" height="210" alt="Tabler" class="navbar-brand-image">'),
               tags$link(rel = "stylesheet",type = 'text/css', href = './css/legenda_leaflet.css'), 
               tags$div( class =  "navbar-nav flex-row order-md-last", 
                 tags$div(class = "nav-item d-none d-md-flex me-3",
                     uiOutput('head_datas')
                       ), #end dib      
                      tags$div(class = "nav-item d-none d-md-flex me-3",
                      actionButton("head_atualizar", label = "Atualizar")
                          ) #end div
                          )), #endheader
   tabler_navbar(
     #brand_url = "https://preview-dev.tabler.io",
     #brand_image = "https://preview-dev.tabler.io/static/logo.svg",
     nav_menu = tabler_navbar_menu(
       id = "current_tab",
       tabler_navbar_menu_item(
         text = "Clipping",
         icon = icon_home(),
         tabName = "home",
         selected = TRUE
       )
     )#,
     #tags$button("update", "Change tab", icon = icon("exchange-alt"))
   ),
   tabler_body(classe = 'page-wrapper',
     tabler_tab_items(
                      
      source('./ui/home.R', , local = T, encoding = 'UTF-8')$value 
    
       
     )
   )
  )
                        