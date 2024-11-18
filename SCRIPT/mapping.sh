#!/bin/bash

#variabili
assembly=$1
fastq1=$2
fastq2=$3
longread=$4

#nome
outputname=$(basename -s _raw.fa "$assembly")

#mapping short reads on assembly
minimap2 -ax sr --MD -t 5 "$assembly" "$fastq1" "$fastq2" > "$outputname"_sr.sam
minimap2 -ax map-pb --MD -t 5 "$assembly" "$longread" > "$outputname"_pac.sam

#converting sam in bam
samtools view -Sb "$outputname"_sr.sam > "$outputname"_sr.bam
samtools view -Sb "$outputname"_pac.sam > "$outputname"_pac.bam

#elimino il sam che non moi serve
rm "$outputname"_sr.sam
rm "$outputname"_pac.sam

#sorting and index
samtools sort -@5 -o "$outputname"_sr_sorted.bam "$outputname"_sr.bam
samtools sort -@5 -o "$outputname"_pac_sorted.bam "$outputname"_pac.bam

samtools index "$outputname"_sr_sorted.bam
samtools index "$outputname"_pac_sorted.bam

#
echo -e "$R1\n$R2" > "$outputname"_sr_sorted.bam
echo -e "$R1\n$R2" > "$outputname"_pac_sorted.bam


