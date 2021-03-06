library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

Name <- c("Eisenbichler M.", "Geiger K.", "Peier K.", "Kobayashi R.", "Stoch K.", 
          "Kraft S.", "Forfang J.", "Johansson R.", "Freitag R.", "Zajc T.", 
          "Huber D.", "Kubacki D.", "Aschenwald P.", "Hayboeck M.", "Ammann S.", 
          "Prevc P.", "Kobayashi J.", "Klimov E.", "Zyla P.", "Ito D.", "Sato Y.", 
          "Koudelka R.", "Jelar Z.", "Fettner M.", "Polasek V.", "Schuler A.", 
          "Boyd-Clowes M.", "Learoyd J.", "Stjernen A.", "Zografski V.")
Nationality <- c("GER", "GER", "SUI", "JPN", "POL", "AUT", "NOR", "NOR", "GER", 
                 "SLO", "AUT", "POL", "AUT", "AUT", "SUI", "SLO", "JPN", "RUS", 
                 "POL", "JPN", "JPN", "CZE", "SLO", "AUT", "CZE", "SUI", "CAN", 
                 "FRA", "NOR", "BUL")
Dist1 <- c(131.5, 131.0, 131.0, 133.5, 128.5, 130.0, 132.5, 128.0, 125.5, 127.0, 126.0,
           128.5, 120.0, 122.0, 122.5, 123.5, 116.0, 126.5, 128.5, 119.0, 120.0, 120.5, 
           118.5, 117.5, 120.0, 117.5, 117.0, 116.5, 124.5, 117.0)
Dist2 <- c(135.5, 130.5, 129.5, 126.5, 129.5, 126.5, 125.5, 129.0, 129.5, 124.0, 125.5, 
           125.5, 128.0, 125.5, 126.0, 122.0, 132.0, 121.0, 121.0, 126.0, 124.0, 120.5, 
           121.0, 122.5, 117.5, 119.0, 118.5, 116.5, 102.0, NA)
Total <- c(279.4, 267.3, 266.1, 262.0, 259.4, 256.1, 250.9, 248.9, 248.7, 245.5, 242.0, 
           240.2, 239.9, 233.7, 230.6, 230.5, 230.0, 229.1, 228.7, 225.7, 221.4, 220.1, 
           219.8, 219.0, 218.2, 212.6, 212.1, 205.9, 185.5, NA)

MS2019_scores <- data.frame(Name, Nationality, Dist1, Dist2, Total) %>% 
  arrange(Total) %>% 
  mutate(Name = factor(Name, Name))

custom.theme <- theme(plot.title = element_text(size = 14, face = "bold"),
                      axis.text = element_text(size = 11),
                      axis.title.x = element_text(size = 12, face = "bold"),
                      legend.title = element_text(size = 12, face = "bold"),
                      legend.text = element_text(size = 11),
                      legend.background = element_rect(colour = "grey"))

ui <- fluidPage(
  titlePanel('Wyniki mistrzostw świata w skokach narciarskich 2019 (konkurs indywidualny)'),
  
  plotOutput("all_contestants", height = 600),
  
  tabsetPanel(
    tabPanel(
      'Porównanie krajów',
      verticalLayout(
        checkboxGroupInput('country_check', choices = unique(Nationality), label = 'Wybierz kraj', inline = TRUE, selected = Nationality[1]),
        plotOutput("plot_countries", height = 600)
      )),
    tabPanel(
      'Porównanie zawodników',
      verticalLayout(
        checkboxGroupInput('contestant_check', choices = Name, label = 'Wybierz zawodnika', inline = TRUE, selected = Name[1]),
        plotOutput("plot_contestants", height = 600)
      )
    )
  )
)

server <- function(input, output) {
  
  output[["all_contestants"]] <- renderPlot({
    MS2019_scores %>% 
      na.omit() %>% 
      ggplot(aes(x = Name, y = Total, fill = Nationality, label = Total)) +
      geom_bar(stat = "identity") + coord_flip() + ylim(0, 300) +
      geom_text(hjust = -0.5) +
      scale_fill_brewer(palette = "Set3", name = "Narodowość") +
      xlab("") + ylab("Suma punktów") +
      ggtitle('Wszyscy zawodnicy') +
      custom.theme
  })
  
  output[["plot_countries"]] <- renderPlot({
    MS2019_scores %>% 
      na.omit() %>% 
      filter(Nationality %in% input[['country_check']]) %>% 
      ggplot(aes(x = Name, y = Total, fill = Nationality, label = Total)) +
      geom_bar(stat = "identity") + coord_flip() + ylim(0, 300) +
      geom_text(hjust = -0.5) +
      scale_fill_brewer(palette = "Set3", name = "Narodowość") +
      xlab("") + ylab("Suma punktów") +
      custom.theme
  })
  
  output[["plot_contestants"]] <- renderPlot({
    MS2019_scores %>% 
      na.omit() %>% 
      filter(Name %in% input[['contestant_check']]) %>% 
      ggplot(aes(x = Name, Total, y = Total, fill = Nationality, label = Total)) +
      geom_bar(stat = "identity") + coord_flip() + ylim(0, 300) +
      geom_text(hjust = -0.5) +
      scale_fill_brewer(palette = "Set3", name = "Narodowość") +
      xlab("") + ylab("Suma punktów") +
      custom.theme
  })
}

shinyApp(ui = ui, server = server)
