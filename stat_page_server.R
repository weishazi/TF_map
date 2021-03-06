
## page for statistics

output$stat_table <-  DT::renderDataTable({
  metadata_tab=paste0(input$stat_database,'_metadata')
  sql=paste0(" select * from ",metadata_tab," where species=",shQuote(input$stat_species)," and type=",shQuote(input$stat_IP))
  dat <- mysql_getData(sql)
  if(input$stat_database == 'cistrome'){
    dat=dat[,-ncol(dat)];dat=dat[,-ncol(dat)];
    
    dat$GSM=createLink(paste0("https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=",dat$GSM),dat$GSM )
    dat$sampleID=createLink(paste0("http://epigenomegateway.wustl.edu/browser/?genome=",'hg38',
                                   "&datahub=http://dc2.cistrome.org/api/datahub/",
                                   dat$sampleID,"&gftk=refGene,full " 
    )
    ,dat$sampleID) 
  }else{
    dat=dat[,-ncol(dat)];dat=dat[,-ncol(dat)];dat=dat[,-ncol(dat)]; 
    dat$sampleID=createLink(paste0("https://www.encodeproject.org/files/",dat$sampleID),dat$sampleID)
    dat$uniqID=createLink(paste0("https://www.encodeproject.org/experiments/",dat$uniqID),dat$uniqID)
  }
  dat
}
,rownames = FALSE, options = list( 
  pageLength = 15,
  lengthMenu = c(15,50,'ALL')
), 
class = 'cell-border stripe',
filter = 'top',
escape = FALSE
)
output$stat_figure <- renderPlot({
  metadata_tab=paste0(input$stat_database,'_metadata')
  sql=paste0(" select * from ",metadata_tab," where species=",shQuote(input$stat_species)," and type=",shQuote(input$stat_IP))
  dat <- mysql_getData(sql)
  par(mfrow=c(2,1))
  tmp=sort(table(dat$cellline),decreasing = T);tmp=tmp[tmp>10]
  barplot( tmp  ,las=2)
  tmp=sort(table(dat$IP),decreasing = T);tmp=tmp[tmp>5]
  barplot( tmp ,las=2)
})
