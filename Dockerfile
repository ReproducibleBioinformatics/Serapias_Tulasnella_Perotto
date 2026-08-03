# Use the rocker/tidyverse image as the base image
FROM r-base:4.3.0

# Install necessary packages and clean up apt cache
RUN apt-get update && apt-get install -y binutils gcc make\
    rna-star \
    fastqc \
    sra-toolkit \
    python3-pip \
    python3-dev \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# in partiolare clean toglie i file compressi scaricati, 
#rm -rf cancella gli elenchi dell'update per non appesantire
#sratoolkit è necessario per scaricare i dati da SRA (traduce i .sra in .fastq), 
#star è necessario per l'allineamento,
#fastqc è necessario per il controllo di qualità, 
#pip3 e python3-dev sono necessari per installare cutadapt

# Install cutadapt and multiqcusing pip and break system packages to avoid conflicts with the base image
RUN pip3 install cutadapt multiqc --break-system-packages

# Installo biocmanager che contiene DESeq2
RUN R -e "install.packages('BiocManager')"
# Poi scarico DESeq2 da biocmanager
RUN R -e "BiocManager::install('DESeq2')"

# Set the working directory
WORKDIR /home/analisi

CMD ["/bin/bash"]