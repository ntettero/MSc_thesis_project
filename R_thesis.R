''' The code in this scripts extracts all the transcripts from plenary 
debates held in the Flemish Parliament in the period 01-01-2000 to 01-11-2022.

In the Pre-Processing section, the data is cleaned and prepared to join together.

In the last section, the data is plotted using the ggplot2 package.
 '''

# installing necessary libraries ------------------------------------------
library(lubridate)
library(tibble)
library(dplyr)
library(data.table)
library(flempar)
library(foreach)
library(purrr)
library(tidyr)
library(stringr)
library(reticulate)
library(scales)
library(ggplot2)
library(RcppRoll)

# Data Collection ---------------------------------------------------------

data.frame(datum_start  = seq(ymd("2000-01-01"),
                              ymd("2022-11-01"),
                              by = 365)) %>%
  mutate(datum_end = lead(datum_start)-1) %>%
  mutate(datum_end = if_else(is.na(datum_end),ymd("2022-11-01"),datum_end))-> date

list <- vector(mode="list",length= nrow(date))

# plenairy debates
for(i in 1:nrow(date)){
  
  output <- try({
    get_work(date_range_from=date$datum_start[[i]]
             ,date_range_to=date$datum_end[[i]]
             ,type="speech"
             ,fact="debates"
             ,plen_comm="plen")
  })
  
   if(class(output) == "try-error"){ 
    
    message("error, will sleep for 1 minute")
    Sys.sleep(60)
    message("slept for 1 minute, let's retry")
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="speech"
               ,fact="debates"
               ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    message("another error, will sleep for 2 minutes")
    Sys.sleep(2*60)
    message("slept for 2 minutes, let's retry")
    
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="speech"
               ,fact="debates"
               ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    message("another error, will sleep for 10 minutes")
    Sys.sleep(10*60)
    message("slept for 10 minutes, let's retry")
    
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="speech"
               ,fact="debates"
               ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    message("another error, powernap of 30 minutes")
    Sys.sleep(30*60)
    message("slept for 30 minutes, let's try one more time")
    
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="speech"
               ,fact="debates"
               ,plen_comm="comm")
    })}
   if(class(output) == "try-error"){ 
    
    stop()
    message("function stopped")
    
    
  }
  
  list[[i]] <- output
  
  saveRDS(output, paste0("~/thesis-code/data/debates/debate",date$datum_start[[i]],".rds"))
  
  message(i,"/",nrow(date))
  
}

# session details
for(i in 1:nrow(date)){
  
  output <- try({
    get_sessions_details(date_range_from=date$datum_start[[i]]
                         ,date_range_to=date$datum_end[[i]]
                         ,plen_comm="plen")
  })
  
  if(class(output) == "try-error"){ 
    
    message("error, will sleep for 1 minute")
    Sys.sleep(60)
    message("slept for 1 minute, let's retry")
    try({
      get_sessions_details(date_range_from=date$datum_start[[i]]
                           ,date_range_to=date$datum_end[[i]]
                           ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    message("another error, will sleep for 2 minutes")
    Sys.sleep(2*60)
    message("slept for 2 minutes, let's retry")
    
    try({
      get_sessions_details(date_range_from=date$datum_start[[i]]
                           ,date_range_to=date$datum_end[[i]]
                           ,plen_comm="plen")
    })}
  if(any(stringr::str_detect(tolower(output[[i]]),"error"))){ 
    
    message("another error, will sleep for 10 minutes")
    Sys.sleep(10*60)
    message("slept for 10 minutes, let's retry")
    
    try({
      get_sessions_details(date_range_from=date$datum_start[[i]]
                           ,date_range_to=date$datum_end[[i]]
                           ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    message("another error, powernap of 30 minutes")
    Sys.sleep(30*60)
    message("slept for 30 minutes, let's try one more time")
    
    try({
      get_sessions_details(date_range_from=date$datum_start[[i]]
                           ,date_range_to=date$datum_end[[i]]
                           ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    stop()
    message("function stopped")
    
    
  }
  
  list[[i]] <- output
  
  saveRDS(output, paste0("~/thesis-code/data/sessiondetails/det",date$datum_start[[i]],".rds"))
  
  message(i,"/",nrow(date))
  
}

# speech - oral questions and interpellations from plenary sessions
get_work(date_range_from=date$datum_start[[i]]
         ,date_range_to=date$datum_end[[i]]
         ,type="speech"
         ,fact="oral_questions_and_interpellations"
         ,plen_comm="plen")

for(i in 1:nrow(date)){
  
  output <- try({
    get_work(date_range_from=date$datum_start[[i]]
             ,date_range_to=date$datum_end[[i]]
             ,type="speech"
             ,fact="oral_questions_and_interpellations"
             ,plen_comm="plen")
  })
  
   if(class(output) == "try-error"){ 
    
    message("error, will sleep for 1 minute")
    Sys.sleep(60)
    message("slept for 1 minute, let's retry")
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="speech"
               ,fact="oral_questions_and_interpellations"
               ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    message("another error, will sleep for 2 minutes")
    Sys.sleep(2*60)
    message("slept for 2 minutes, let's retry")
    
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="speech"
               ,fact="oral_questions_and_interpellations"
               ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    message("another error, will sleep for 10 minutes")
    Sys.sleep(10*60)
    message("slept for 10 minutes, let's retry")
    
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="speech"
               ,fact="oral_questions_and_interpellations"
               ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    message("another error, powernap of 30 minutes")
    Sys.sleep(30*60)
    message("slept for 30 minutes, let's try one more time")
    
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="speech"
               ,fact="oral_questions_and_interpellations"
               ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    stop()
    message("function stopped")
    
    
  }
  
  list[[i]] <- output
  
  saveRDS(output, paste0("~/thesis-code/data/oqaispeech/oqaispeech",date$datum_start[[i]],".rds"))
  
  message(i,"/",nrow(date))
  
}

# details - oral questions and interpellations from plenary sessions
for(i in 1:nrow(date)){
  
  output <- try({
    get_work(date_range_from=date$datum_start[[i]]
             ,date_range_to=date$datum_end[[i]]
             ,type="details"
             ,fact="oral_questions_and_interpellations"
             ,plen_comm="plen")
  })
  
   if(class(output) == "try-error"){ 
    
    message("error, will sleep for 1 minute")
    Sys.sleep(60)
    message("slept for 1 minute, let's retry")
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="details"
               ,fact="oral_questions_and_interpellations"
               ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    message("another error, will sleep for 2 minutes")
    Sys.sleep(2*60)
    message("slept for 2 minutes, let's retry")
    
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="details"
               ,fact="oral_questions_and_interpellations"
               ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    message("another error, will sleep for 10 minutes")
    Sys.sleep(10*60)
    message("slept for 10 minutes, let's retry")
    
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="details"
               ,fact="oral_questions_and_interpellations"
               ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    message("another error, powernap of 30 minutes")
    Sys.sleep(30*60)
    message("slept for 30 minutes, let's try one more time")
    
    try({
      get_work(date_range_from=date$datum_start[[i]]
               ,date_range_to=date$datum_end[[i]]
               ,type="details"
               ,fact="oral_questions_and_interpellations"
               ,plen_comm="plen")
    })}
   if(class(output) == "try-error"){ 
    
    stop()
    message("function stopped")
    
    
  }
  
  list[[i]] <- output
  
  saveRDS(output, paste0("~/thesis-code/data/oqaidetails/oqaidetails",date$datum_start[[i]],".rds"))
  
  message(i,"/",nrow(date))
  
}

# get session details
for(i in 1:nrow(date)){
  
  output <- try({
    get_sessions_details(date_range_from = date$datum_start[[i]]
                         ,date_range_to  = date$datum_end[[i]]
                         ,use_parallel=TRUE
                         ,plen_comm="plen")
  })
  
  if(class(output) == "try-error"){
    
    message("error, will sleep for 1 minute")
    Sys.sleep(60)
    message("slept for 1 minute, let's retry")
    try({
      get_sessions_details(date_range_from = date$datum_start[[i]]
                           ,date_range_to  = date$datum_end[[i]]
                           ,use_parallel=TRUE
                           ,plen_comm="plen")
    })}
  
   if(class(output) == "try-error"){
    stop()
    message("function stopped")
    
  }
  
  list[[i]] <- output
  
  saveRDS(output, paste0("~/thesis-code/data/sessiondetails/sessiondetails",date$datum_start[[i]],".rds"))
  
  message(i,"/",nrow(date))
  
}






# information on MPs (Members of Parliament)
huidig <- get_mp(selection="current"
                 , fact="raw"
                 , use_parallel=TRUE)

voorgaande <- get_mp(selection="former"
                     ,fact="raw"
                     , use_parallel=TRUE)

huidig %>%
  tibble::tibble(vv = .) %>%
  tidyr::unnest_wider(vv) %>%
  dplyr::select(id_mp=id,voornaam, achternaam=naam,geslacht,geboortedatum,geboorteplaats,huidigefractie,lidmaatschap) %>%
  tidyr::unnest_wider(huidigefractie, names_sep="_") %>%
  tidyr::unnest_wider(huidigefractie_1, names_sep="_") %>%
  tidyr::unnest_wider(lidmaatschap, names_sep="_") %>%
  tidyr::unnest(lidmaatschap_1) %>%
  tidyr::unnest(c( fractie)) %>%
  dplyr::select(id_mp,voornaam, achternaam,geslacht,geboortedatum,geboorteplaats,party_id_current=huidigefractie_1_id,party_naam_current = huidigefractie_1_naam,naam,datumVan,datumTot,`zetel-aantal`) %>%
  dplyr::mutate(geboortedatum = lubridate::date(lubridate::ymd_hms(geboortedatum)))  -> huidig_clean


voorgaande %>%
  tibble::tibble(vv = .) %>%
  tidyr::unnest_wider(vv) %>%
  dplyr::select(id_mp=id,voornaam, achternaam=naam,geslacht,geboortedatum,geboorteplaats,huidigefractie,lidmaatschap) %>%
  tidyr::unnest_wider(huidigefractie, names_sep="_") %>%
  tidyr::unnest_wider(huidigefractie_1, names_sep="_") %>%
  tidyr::unnest_wider(lidmaatschap, names_sep="_") %>%
  tidyr::unnest(lidmaatschap_1) %>%
  tidyr::unnest(c( fractie)) %>%
  dplyr::select(id_mp,voornaam, achternaam,geslacht,geboortedatum,geboorteplaats,party_id_current=huidigefractie_1_id,party_naam_current = huidigefractie_1_naam,naam,datumVan,datumTot,`zetel-aantal`) %>%
  dplyr::mutate(geboortedatum = lubridate::date(lubridate::ymd_hms(geboortedatum)))  -> voorgaande_clean

# merging all the collected rds files of each interval to one data frame
mp <- rbind(huidig_clean,voorgaande_clean)

write.csv(mp, file = "~/thesis-code/data/df_mp.csv")

speech <- list.files( path = "~/thesis-code/data/debates/", pattern = "*.rds", full.names = TRUE ) %>%
  map_dfr(readRDS)

write.csv(speech, file =  "~/thesis-code/data/df_speech.csv")

oqaispeech <- list.files( path = "~/thesis-code/data/oqaispeech/", pattern = "*.rds", full.names = TRUE ) %>%
  map_dfr(readRDS)

write.csv(oqaispeech, "~/thesis-code/data/df_oqaispeech.csv")


# details have some different variables over time, have to be merged using a loop
#oqai details
pathoqai <- fs::dir_ls("~/thesis-code/data/oqaidetails/")

oqailist <- vector(mode="list",length= length(pathoqai))

for(i in seq_along(pathoqai)){
  readRDS(pathoqai[[i]]) %>% 
    select(-result_objecttype, -result_contacttype, -result_samenhang, 
           -result_procedureverloop, -result_handelingcommissie, 
           -result_handelingenplenaire, -result_hasintervenienteningroupedcontactmap) -> oqailist[[i]]
} 

oqaidetails <- rbindlist(oqailist, fill = TRUE)
oqaidetails <- as.data.frame(oqaidetails)
oqaidetails <- apply(oqaidetails,2,as.character)
oqaidetails <- as.data.frame(oqaidetails)
write.csv(oqaidetails, "~/thesis-code/data/df_oqaidetails.csv")

#session details to one df
pathsessions <- fs::dir_ls("~/thesis-code/data/sessiondetails/")

sessionlist <- vector(mode="list",length= length(pathsessions))

for(i in seq_along(pathsessions)){
  readRDS(pathsessions[[i]]) %>% 
    select(id_verg, datumbegin, datumeinde, journaallijn_id, id_fact,
           type_specifiek, onderwerp, titel) -> sessionlist[[i]]
} 

sessiondetails <- rbindlist(sessionlist)


# Data Pre-Processing ----------------------------------------------------------
#using session details to join oral questions and interpellations speech and details

sessiondetails %>%
  as_tibble %>%
  left_join(oqaidetails %>%
              distinct %>%
              mutate(id_fact = as.numeric(id_fact)), by=c("id_fact"="id_fact")) %>%
  left_join(oqaispeech%>%
              distinct %>%
              mutate(journaallijn_id = as.numeric(journaallijn_id)), by=c("journaallijn_id"="journaallijn_id")) -> oqai





# cleaning the transcripts
speech %>%
  mutate(text = str_to_lower(text)) %>%
  mutate(text = str_replace_all(text, "<p>", "")) %>%
  mutate(text = str_replace_all(text, "</p>", "")) %>%
  mutate(text = str_replace_all(text, "<em>", "")) %>%
  mutate(text = str_replace_all(text, "/em>", "")) %>%
  mutate(text = str_replace_all(text, "<strong>", "")) %>%
  mutate(text = str_replace_all(text, "</strong>", "")) %>%
  mutate(text = str_replace(text, "&#39;", "'")) -> speech_clean

speech_clean$journaallijn_id <- as.integer(speech_clean$journaallijn_id)

write.csv(speech_clean, file =  "~/thesis-code/data/df_speechclean.csv")

# cleaning the details data frame
details %>% 
  select(id_verg, datumbegin, journaallijn_id, id_fact) %>%
  mutate(datum = as.Date(datumbegin, format = "%Y-%m-%d")) %>% 
  select(id_verg, datum, journaallijn_id, id_fact) -> details

write.csv(details, "~/thesis-code/data/df_detailsclean.csv")


# cleaning and mutating the MP data frame
mp %>%
  select(id_mp, voornaam, achternaam, geslacht, geboortedatum, geboorteplaats, naam, datumVan, datumTot, zetel_aantal  = `zetel-aantal`) %>%
  mutate(datumVan = as.Date(datumVan, format = "%Y-%m-%d")) %>%
  mutate(datumTot = as.Date(datumTot, format = "%Y-%m-%d")) %>%
  mutate(jaarbegin = format(datumVan, "%Y")) %>%
  mutate(jaareind = format(datumTot, "%Y")) -> mp

# if jaareind is NA, MP is currently in the Parliament. Therefore, NA is set to 2022
mp$jaareind[is.na(mp$jaareind)] <- 2022

mp %>%
  mutate(aantal_zittingsjaren = round(time_length(difftime(datumTot, datumVan), "years"))) %>%
  group_by(id_mp) -> mp

#create new row for each year someone is/was in parliament -> now we can join the speech and mps
#source(https://stackoverflow.com/questions/67571751/use-range-in-column-values-to-create-new-rows-in-r)
mp %>%
  mutate(jaar = map2(jaarbegin, jaareind, seq)) %>%
  unnest(jaar) %>%
  group_by(id_mp, jaar) %>%
  slice_max(jaarbegin) %>%
  ungroup -> mp_exploded

write.csv(mp_exploded, file = "~/thesis-code/data/df_mpexploded.csv")
mp_exploded <- read.csv("~/thesis-code/data/df_mpexploded.csv")

#oqai check themas voor klimaat en milieu
oqai %>%
  filter(result_thema_1 %in% c("Natuur en Milieu") | result_thema_2 %in% c("Natuur en Milieu") |
           result_thema_3 %in% c("Natuur en Milieu") | result_thema_4 %in% c("Natuur en Milieu") |
           result_thema_5 %in% c("Natuur en Milieu") | result_thema_6 %in% c("Natuur en Milieu")) %>%
  mutate(datum = as.Date(datumbegin, format = "%Y-%m-%d")) %>%
  select(-datumbegin, -datumeinde) %>%
  mutate(jaar = format(datum, "%Y"))-> natuur_milieu


# Joining the data frames to one final data frame -------------------------
speech_clean %>%
  
  left_join(details, by = c("journaallijn_id" = "journaallijn_id")) %>% 
    mutate(jaar = as.integer(format(datum, "%Y"))) %>%
    
  left_join(mp, by = c("persoon_id" = "id_mp", "jaar" = "jaar")) -> df_final
  
write.csv(df_final, file = "~/thesis-code/data/df_final.csv")

# joining klimaat en milieu dataframe to the mp dataframe
natuur_milieu %>%
  mutate(jaar = as.integer(jaar)) %>%
  
  left_join(mp_exploded, by = c("persoon_id"="id_mp", "jaar" = "jaar")) -> df_klimaatoqai
#cleaning the text in the df_klimaat
df_klimaatoqai %>%
  mutate(text = str_to_lower(text)) %>%
  mutate(text = str_replace_all(text, "<p>", "")) %>%
  mutate(text = str_replace_all(text, "</p>", "")) %>%
  mutate(text = str_replace_all(text, "<em>", "")) %>%
  mutate(text = str_replace_all(text, "/em>", "")) %>%
  mutate(text = str_replace_all(text, "<strong>", "")) %>%
  mutate(text = str_replace_all(text, "</strong>", "")) %>%
  mutate(text = str_replace_all(text, "</span>", "")) %>%
  mutate(text = str_replace_all(text, "<span>", "")) %>%
  mutate(text = str_replace_all(text, "<html>", "")) %>%
  mutate(text = str_replace_all(text, "<head>", "")) %>%
  mutate(text = str_replace_all(text, "</head>", "")) %>%
  mutate(text = str_replace_all(text, "<title>", "")) %>%
  mutate(text = str_replace_all(text, "</title>", "")) %>%
  mutate(text = str_replace_all(text, "<body>", "")) %>%
  mutate(text = str_replace_all(text, "</body>", "")) %>%
  mutate(text = str_replace_all(text, "<sub>", "")) %>%
  mutate(text = str_replace_all(text, "</sub>", "")) %>%
  mutate(text = str_replace_all(text, "&#8217;", "")) %>%
  mutate(text = str_replace_all(text, "&#8216;", "")) %>%
  mutate(text = str_replace_all(text, "&#8211;", "")) %>%
  mutate(text = gsub("\r", "", text)) %>%
  mutate(text = gsub("\n", "", text)) %>%
  mutate(text = str_replace_all(text, "&#235;", "ë")) %>%
  mutate(text = str_replace_all(text, "&#246;", "ö")) %>%
  mutate(text = str_replace_all(text, "&#233;", "é")) %>%
  mutate(text = str_replace_all(text, "&eacute", "é")) %>%
  mutate(text = str_replace_all(text, "&#239;", "ï")) %>%
  mutate(text = str_replace_all(text, "&iuml;", "ï")) %>% 
  mutate(text = str_replace_all(text, "&#146;", "'")) %>%
  mutate(text = str_replace_all(text, "&#147;", "'")) %>%i
  mutate(text = str_replace_all(text, "&#150;", "-")) %>%
  mutate(text = str_replace_all(text, "&euml;", "ë")) %>%
  mutate(text = str_replace_all(text, "&eacute;", "é")) %>%
  mutate(text = str_replace_all(text, "&#39;", "'")) %>%
  mutate(text = str_replace_all(text, '&#8220;', '"')) %>%
  mutate(text = str_replace_all(text, '&#8221;', '"')) %>%
  mutate(text = str_replace_all(text, '<span style="font-style:italic;">', "")) %>%
  mutate(text = str_replace_all(text, '<span style="vertical-align:sub;">', "")) %>%
  mutate(text = str_replace(text, "&#39;", "'")) %>%
  mutate(text = str_replace(text, "&rsquo;", "'"))-> df_klimaatoqai

#write.csv(df_klimaatoqai, "~/thesis-code/data/df_klimaatoqai.csv")

#filter out all text by de voorzitter. Needs to stay neutral
df_klimaatoqai %>%
  filter(sprekertitel != "De voorzitter") -> df_klimaatoqai
write.csv(df_klimaatoqai, "~/thesis-code/df_klimaatoqai-v.csv")
#df_klimaatoqai <- read.csv("~/thesis-code/df_klimaatoqai-v.csv")


#get back full dataset with sentiment scores for evaluation and building graphs with ggplot
df <- read.csv("~/thesis-code/data/df_full_sent_multi.csv")

#plotting sentiment scores
#links <- list("Groen","Vooruit","sp·a","sp·a + VlaamsProgressieven","sp·a-spirit","Groen!","AGALEV","VLD-Vivant","SP","BSP","CVP","KP")
#rechts <- list("Open Vld","Vlaams Belang","N-VA","VB","VU&ID","VU","PVV","LDD","Lijst Dedecker","Rossem","FDF","RAD")
#progressief <- list("Groen", "ECOLO", "N-VA", "SP", "sp·a","sp·a + VlaamsProgressieven","sp·a-spirit","Groen!", "Open Vld", "Vooruit")
#conservatief <- list("Vlaams Belang", "VU")

groen <- c("AGALEV", "Groen!", "SLP")
cd_v <- c("CVP")
vooruit <- c("sp·a","sp·a + VlaamsProgressieven","sp·a-spirit","SP")

regering <- read.csv("~/thesis-code/regeringen.csv")

regering %>%
  mutate(id = seq.int(nrow(regering))) %>%
  mutate(start = as.Date(Periode_van, format= "%Y-%m-%d"), end = as.Date(Periode_tot, format= "%Y-%m-%d")) %>%
  mutate(datum = map2(start, end, seq, by ="day")) %>%
  unnest(datum) %>%
  group_by(ID, datum) %>%
  slice_max(start) %>%
  ungroup %>%
  select(regering = Regering, partij = Partijen, start, end, datum) -> regering_exploded

new_regering <- c("2019-10-02", "2014-07-25", "2009-07-13", "2007-06-28", "2004-07-20")
new_regering_date <- data.frame(datum = as.Date(new_regering))

df %>%
  select(datum, jaar, sprekertitel, result_zittingsjaar, naam.y, sentiment_score_multi, zetel_aantal) %>%
  mutate(minister = ifelse(startsWith(sprekertitel, "Minister"), "Minister", "Parliamentarian")) %>%
  mutate(Orientation = ifelse(naam.y %in% links, "links", "rechts")) %>%
  mutate(prog = ifelse(naam.y %in% progressief, "progressief", "conservatief")) %>%
  mutate(datum = as.Date(datum))-> selectie

selectie %>%
  left_join(regering_exploded, by = c("datum" = "datum", "naam.y" = "partij")) %>% 
  mutate(inregering = ifelse(!is.na(regering), 'Coalition', 'Opposition')) %>% 
  select(datum, jaar, sprekertitel, result_zittingsjaar, partij = naam.y, sentiment_score_multi
         , zetel_aantal, minister, orientation = Orientation, prog, inregering) -> selectie

copy <- selectie

copy %>% 
  mutate(partij = replace(partij, partij == "sp·a", "Vooruit")) %>%
  mutate(partij = replace(partij, partij == "sp·a + VlaamsProgressieven", "Vooruit")) %>%
  mutate(partij = replace(partij, partij == "sp·a-spirit", "Vooruit")) %>%
  mutate(partij = replace(partij, partij == "SP", "Vooruit")) %>%
  mutate(partij = replace(partij, partij == "AGALEV", "Groen")) %>%
  mutate(partij = replace(partij, partij == "Groen!", "Groen")) %>%
  mutate(partij = replace(partij, partij == "SLP", "Groen")) -> changed_names

changed_names %>%
  filter(partij == "Groen" | partij == "Vooruit" | partij == "CD&V" 
         | partij == "Vlaams Belang" | partij == "Open Vld" |
           partij == "N-VA") -> largest_parties

#OVERALL USED
selectie %>%
  group_by(datum) %>%
  summarise(mean_sentiment = mean(sentiment_score_multi)) %>%
  ggplot(aes(x = as.Date(datum), y = mean_sentiment,)) +
  geom_line(color = "darkgreen") +
  geom_smooth(method = lm, se=TRUE, size=0.5, color = "darkgreen", fill = "pink") +
  geom_hline(yintercept = 3, color = "black", linetype = "dashed") +
  geom_vline(data = new_regering_date, aes(xintercept = c(datum)), linetype = "dashed", color = "grey") +
  scale_x_date(date_breaks = "2 year", date_labels = "%Y")  +
  ylab("Sentiment" ) +
  xlab("Time") +
  theme(axis.text.x = element_text(color = "grey20", size = 18, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "grey20", size = 18, angle = 0, hjust = 1, vjust = 0, face = "plain"),  
        axis.title.x = element_text(color = "grey20", size = 20, angle = 0, hjust = .5, vjust = 0, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 20, angle = 90, hjust = .5, vjust = .5, face = "plain")) +
  theme(panel.background = element_blank()) 



#MINISTER KAMERLID USED?
selectie %>%
  group_by(datum, minister) %>%
  summarise(mean_sentiment = mean(sentiment_score_multi)) %>%
  mutate(datum = ymd(datum ))%>%
  group_by(minister) %>%
  arrange(datum) %>%
  mutate(rol_mean_sentiment_14 = roll_mean(mean_sentiment, 14, align = "right", fill = NA) ) %>%
  ggplot(aes(x = datum, y = rol_mean_sentiment_14, color = minister)) +
  geom_line() +
  geom_smooth(method = lm, se=TRUE, size=0.5, fill = "pink") +
  scale_x_date(date_breaks = "2 year", date_labels = "%Y")  +
  ylab("Sentiment") +
  xlab("Time") +
  theme(axis.text.x = element_text(color = "grey20", size = 18, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "grey20", size = 18, angle = 0, hjust = 1, vjust = 0, face = "plain"),  
        axis.title.x = element_text(color = "grey20", size = 20, angle = 0, hjust = .5, vjust = 0, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 20, angle = 90, hjust = .5, vjust = .5, face = "plain")) +
  theme(panel.background = element_blank()) +
  theme(legend.key.size = unit(1.5, "cm"),legend.text = element_text("black", size=14), legend.position = "top", legend.key = element_rect(fill = "white")) +
  scale_color_discrete(name = NULL) 


#COA OPPO USED
largest_parties %>%
  group_by(datum, inregering) %>%
  summarise(mean_sentiment = mean(sentiment_score_multi)) %>%
  mutate(datum = ymd(datum ))%>%
  group_by(inregering) %>%
  arrange(datum) %>%
  mutate(rol_mean_sentiment_10 = roll_mean(mean_sentiment, 10, align = "right", fill = NA) ) %>%
  ggplot(aes(x = datum, y = rol_mean_sentiment_10, colour = inregering)) +
  geom_line() +
  geom_smooth(method = lm, se=TRUE, fill = "pink", size=0.5) +
  geom_hline(yintercept = 3, color = "black", linetype = "dashed") +
  geom_vline(data = new_regering_date, aes(xintercept = c(datum)), linetype = "dashed", color = "grey") +
  scale_x_date(date_breaks = "2 year", date_labels = "%Y")  +
  ylab("Sentiment" ) +
  xlab("Time") +
  theme(axis.text.x = element_text(color = "grey20", size = 18, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "grey20", size = 18, angle = 0, hjust = 1, vjust = 0, face = "plain"),  
        axis.title.x = element_text(color = "grey20", size = 20, angle = 0, hjust = .5, vjust = 0, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 20, angle = 90, hjust = .5, vjust = .5, face = "plain")) +
  theme(panel.background = element_blank()) +
  theme(legend.key.size = unit(1.5, "cm"),legend.text = element_text("black", size=16), legend.position = "top", legend.key = element_rect(fill = "white")) +
  scale_color_discrete(name = NULL) 

largest_parties %>%
  group_by(partij, month = lubridate::floor_date(datum, '3 months')) %>%
  summarize(mean = mean(sentiment_score_multi)) -> largest_parties

#PARTIJ USED
largest_parties %>%
  mutate(rol_mean_sentiment_10 = roll_mean(mean, 5, align = "right", fill = NA) ) %>%
  ggplot(aes(x = month, y = rol_mean_sentiment_10, colour = partij)) +
  geom_line() +
  geom_smooth(method = lm, se=TRUE, size=0.5, fill = "pink") +
  geom_hline(yintercept = 3, color = "black", linetype = "dashed") +
  geom_vline(data = new_regering_date, aes(xintercept = c(datum)), linetype = "dashed", color = "grey") +
  scale_x_date(date_breaks = "2 year", date_labels = "%Y")  +
  ylab("Sentiment" ) +
  xlab("Time") +
  theme(axis.text.x = element_text(color = "grey20", size = 18, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "grey20", size = 18, angle = 0, hjust = 1, vjust = 0, face = "plain"),  
        axis.title.x = element_text(color = "grey20", size = 20, angle = 0, hjust = .5, vjust = 0, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 20, angle = 90, hjust = .5, vjust = .5, face = "plain")) +
  theme(panel.background = element_blank()) +
  theme(legend.key.size = unit(1.5, "cm"),legend.text = element_text("black", size=14), legend.position = "top", legend.key = element_rect(fill = "white")) +
  scale_color_discrete(name = NULL) 

