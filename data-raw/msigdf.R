# http://bioinf.wehi.edu.au/software/MSigDB/

library(plyr)
library(dplyr)
library(tidyr)
library(stringr)

# human data
load(url("http://bioinf.wehi.edu.au/software/MSigDB/human_H_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/human_c1_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/human_c2_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/human_c3_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/human_c4_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/human_c6_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/human_c5_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/human_c7_v5p1.rdata"))

# mouse data
load(url("http://bioinf.wehi.edu.au/software/MSigDB/mouse_H_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/mouse_c1_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/mouse_c2_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/mouse_c3_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/mouse_c4_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/mouse_c6_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/mouse_c5_v5p1.rdata"))
load(url("http://bioinf.wehi.edu.au/software/MSigDB/mouse_c7_v5p1.rdata"))

msigdf <- list()
for (i in ls(pattern="^Hs\\.|^Mm\\.")) {
  message(i)
  msigdf[[i]] <- eval(parse(text=i)) %>%
    ldply(function(x) data_frame(entrez=x), .id="geneset") %>%
    filter(entrez!="-") %>%
    mutate(entrez=as.integer(entrez), geneset=as.character(geneset)) %>%
    tbl_df()
}
rm(list=ls(pattern="^Hs\\.|^Mm\\."), i)
msigdf <- msigdf %>%
  bind_rows(.id="x") %>%
  separate(x, into=c("org", "collection")) %>%
  mutate(collection=collection %>% str_replace("H", "hallmark"))
msigdf

msigdf_mouse <- msigdf %>% filter(org=="Mm") %>% select(-org)
msigdf <- msigdf %>% filter(org=="Hs") %>% select(-org)

msigurls <- msigdf %>%
  distinct(collection, geneset) %>%
  mutate(url=paste0("http://www.broadinstitute.org/gsea/msigdb/cards/", geneset))

