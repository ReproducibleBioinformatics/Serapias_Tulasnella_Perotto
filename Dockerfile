# Use the official R 4.3.1 base image
FROM r-base:4.3.1

# Install necessary system packages and libraries required for complex R/Bioconductor packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    binutils \
    gcc \
    g++ \
    make \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libuv1-dev \
    libfreetype-dev \
    pkg-config \
    libgmp3-dev \
    libmpfr-dev \
    libbz2-dev \
    liblzma-dev \
    libsqlite3-dev \
    libgit2-dev \
    unixodbc-dev \
    libcairo2-dev \
    rna-star \
    fastqc \
    samtools \
    sra-toolkit \
    python3-pip \
    python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/lists/*

# Install cutadapt and multiqc using pip
RUN pip3 install --no-cache-dir cutadapt multiqc --break-system-packages

# Copia il file con la lista dei pacchetti nella cartella temporanea
COPY r_packages.txt /tmp/r_packages.txt

# Script R ottimizzato: installa prima BiocManager, poi i pacchetti critici e infine il resto della lista
RUN cat << 'EOF' > /tmp/install.R
lines <- readLines('/tmp/r_packages.txt')
header_line <- grep('^Package\\s+Version', lines)
data_lines <- if (length(header_line) > 0) lines[(header_line + 1):length(lines)] else lines[4:length(lines)]
pkgs <- sapply(strsplit(trimws(data_lines), '\\s+'), function(x) x[1])
pkgs <- pkgs[!is.na(pkgs) & pkgs != '']
base_pkgs <- c('base', 'compiler', 'datasets', 'graphics', 'grDevices', 'grid', 'methods', 'parallel', 'splines', 'stats', 'stats4', 'tcltk', 'tools', 'utils')
pkgs <- setdiff(pkgs, base_pkgs)

if (!requireNamespace('BiocManager', quietly = TRUE)) {
    install.packages('BiocManager', repos='https://cloud.r-project.org')
}

# 1. Installa prima esplicitamente i pacchetti più critici/pesanti
critical_pkgs <- c('tidyverse', 'clusterProfiler', 'DESeq2', 'edgeR', 'limma', 'AnnotationDbi')
message('--- Installazione pacchetti critici ---')
BiocManager::install(critical_pkgs, update = FALSE, ask = FALSE, force = TRUE)

# 2. Installa tutto il resto della lista
remaining_pkgs <- setdiff(pkgs, critical_pkgs)
message('--- Installazione rimanenti pacchetti dalla lista ---')
BiocManager::install(remaining_pkgs, update = FALSE, ask = FALSE, force = TRUE)
EOF

# Esegue lo script R e pulisce i file temporanei
RUN Rscript /tmp/install.R && \
    rm /tmp/r_packages.txt /tmp/install.R

# Set the working directory
WORKDIR /home/analisi

CMD ["/bin/bash"]