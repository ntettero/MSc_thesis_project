FROM rocker/r-ver:4.2.1

ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=daily
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV PATH=/usr/lib/rstudio-server/bin:$PATH

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh

RUN apt-get update && \
    apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libgdal-dev \
    libsodium-dev \
    libudunits2-dev \
    unixodbc \
    libpq-dev \
    curl \
    zlib1g-dev \
    libreoffice \
    libmagick++-6.q16-dev \
    libnss3 \
    libnss3-dev \
    libcairo2-dev \
    libjpeg-dev \ 
    libgif-dev \
&& apt-get clean \ 
&& rm -rf /var/lib/apt/lists/ \ 
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds
ENV LD_LIBRARY_PATH=/usr/lib/libreoffice/program/       

RUN apt-get update
RUN apt-get install libpoppler-dev

RUN mkdir /home/rstudio/miniconda 
RUN chmod ugo+rwx /home/rstudio/miniconda

RUN install2.r -e \
    -r 'http://cran.rstudio.com' \
    reticulate \
    && rm -rf /tmp/downloaded_packages

RUN R -e "install.packages(c('remotes', 'pdftools', 'lubridate', 'tibble', 'dplyr', 'data.table', 'purr', 'scales', 'ggplot2','RccpRoll'), dependencies=TRUE, repos='https://cran.rstudio.com')"

RUN Rscript -e "remotes::install_github('PolscienceAntwerp/flempar')"
RUN Rscript -e "reticulate::install_miniconda(path='/home/rstudio/miniconda')" 
RUN Rscript -e "reticulate::conda_install('r-reticulate', 'pandas','numpy', 'torch', 'sklearn', 'transformers','tqdm', 'random','conda='/home/rstudio/miniconda/bin/conda')"  

EXPOSE 8787

CMD ["/init"]niENV