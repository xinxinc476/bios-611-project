FROM rocker/verse
RUN R -e "install.packages(\"shiny\")"
RUN R -e "install.packages(\"plotly\")"
