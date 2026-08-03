1. Dataset di riferimento
Per il training è fondamentale lavorare su dati reali dello stesso sistema biologico.

1.1 Dataset fungo
GEO accession: GSE86968
Link: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE86968
Contenuto:
RNA-seq di Tulasnella calospora
condizioni: simbiosi con protocormi di Serapias, micelio free-living

Questo dataset permette di replicare uno dei confronti chiave del vostro progetto: fungo in interazione vs fungo indipendente. (CERCARE DI PARTIRE DA UN DOCKER FATTO E MODIFICARLO (rocker))
Fai una lista dei tool: 
- sra toolkit (scarica dati da SRA)
- STAR (ALLINEAMENTO)
- R  (DEseq2)
- pacchetti per gestire python
- FASTQC
- cutadapt (tagliare adattatori nei reads)
- trim_galorc (per il trimming?)
- 
Una volta capito che tool utilizzare contattare Luca che fa il lavoro sporco.

Col docker fatto 
1. Scarico fastq tramite SRA (dump fastq… utilizza il docker sra https://github.com/ncbi/sra-tools/wiki/HowTo:-fasterq-dump )
2. Fastqc -> guardo la qualita’ dei fastq (https://www.youtube.com/watch?v=QXi3jwSS28A)
3. trimming -> (guardare sequenza adattatore e rimuoverla con cutadapt)
4. fastqc again
5. fasta -> genoma. (scarico genoma)
6. Creazione index  (STAR index)
7. allineamento  (STAR mem) -> genera un bam
8. creazione matrice di conte  (STAR con GTF)-> 1 file csv. 
9. Fare downstream analysis come nel video del biohack

1.2 Dataset pianta
GEO accession: GSE87120
Link: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE87120
Contenuto:
RNA-seq di Serapias vomeracea
condizioni:
micorrizata
asimbiotica
Questo dataset è il complemento naturale del precedente e permette di studiare la risposta della pianta alla simbiosi.
