
all: dynamic.bn.html

../data/prepd.rds: ../data/FishEnvBaltic.csv.bz2
	Rscript preprocess.R

prepare.and.explore.html: ../data/prepd.rds prepare.and.explore.Rmd
	Rscript -e "rmarkdown::render('prepare.and.explore.Rmd', 'html_document')"

dynamic.bn.html: prepare.and.explore.html dynamic.bn.Rmd
	Rscript -e "rmarkdown::render('dynamic.bn.Rmd', 'html_document')"

