FROM rocker/r-ver:4.4.0
RUN apt-get update && apt-get install -y \
    texlive \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-science
RUN Rscript -e "install.packages(c('stargazer', 'ggplot2'), repos='https://cloud.r-project.org')"
WORKDIR /project
