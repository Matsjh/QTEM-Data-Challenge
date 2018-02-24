# Server function
server <- function(input, output, session) {
  
output$test <- renderText(input$selection)
  
#token <- input$auth

observeEvent(input$update, {
  
id.selection <- fb.page.id$id[match(input$selection,fb.page.id$page)]
token <- input$auth


#Get facebook posts 
df <- getPage(id.selection, token, n=5) 
df <- subset(df, comments_count>0)

fb.msg = fb.date =  NULL

# Get Comments from posts
for (i in df$id) {
  post = getPost(i, token)
  fb.msg = rbind(fb.msg, as.data.frame(post$comments$message))
  fb.date = rbind(fb.date, as.data.frame(post$comments$created_time))
}

# Organize
user.cmt = cbind(as.Date(fb.date$`post$comments$created_time`),fb.msg)
colnames(user.cmt) <- c("date","comments")
user.cmt$comments <- as.character(user.cmt$comments)

# Drop comments less than 40 characters long 
user.cmt <- subset(user.cmt, nchar(as.character(user.cmt$comments))>25)

# remove URLs
user.cmt$comments <- gsub('https? ?[:;,]?/{,3}(www.)?[^ ]*', '', user.cmt$comments) 

# Take out apostrophes
user.cmt$comments <- iconv(user.cmt$comments, "", "ASCII", "byte")

# Clean out emoji scraps
cleanFun <- function(scrap) {
  return(gsub("<.*?>", "", scrap))
}

user.cmt$comments <- cleanFun(user.cmt$comments)

# Preview data
glimpse(user.cmt$comments[1])

#Create weekday variable
user.cmt$day <- weekdays(user.cmt$date)

#Process text
processed <- textProcessor(user.cmt$comments, metadata = user.cmt,language = "en", wordLengths = c(3, Inf), striphtml = T)

out <- prepDocuments(processed$documents, processed$vocab, processed$meta, lower.thresh = 1)
docs <- out$documents
vocab <- out$vocab
meta <-out$meta

# STM model
k5 <- stm(out$documents, out$vocab, K = 5, max.em.its = 30, data = out$meta, init.type = "Spectral")

output$plot.model <- renderPlot({plot.STM(k5, type = "summary", xlim = c(0, .5))})

output$plot.cloud <- renderPlot({cloud(k5, topic = 5, scale = c(4,1), max.words = 100)})


})

}