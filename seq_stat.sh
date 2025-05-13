#!/bin/bash

############################################
#       NGS Data Stat Pipeline v1.5        #
#         Hongjiang Liu, 05/09/25          #
############################################


# MD5 & seqkit stats

# CPU threads (default = max/2)
## v1.5
CPU_THREAD_MAX=$(grep -c '^processor' /proc/cpuinfo)
CPU_THREAD=$((CPU_THREAD_MAX / 2))

## Including .fq .fastq .fq.gz .fastq.gz

## v1.3
## gzip .fasta & .fq into .fasta.gz & .fq.gz
if command -v pigz &>/dev/null; then
    find . -type f \( -iname "*.fq" -o -iname "*.fastq" \) -exec pigz --processes ${CPU_THREAD} {} +
else
    find . -type f \( -iname "*.fq" -o -iname "*.fastq" \) -exec gzip {} +
fi

if [ ! "$(command -v seqkit)" ]; then
  echo "ERROR: Seqkit not found." >&2
  exit 1
fi

# MD5 checksums
echo "MD5..."
find . -type f -regex '.*\.f\(ast\)?q\.gz' -exec md5sum {} + > md5_checksums.txt &

## v1.4
# SHA256 checksums
echo "SHA256..."
find . -type f -regex '.*\.f\(ast\)?q\.gz' -exec sha256sum {} + > sha_checksums.txt &

# seqkit stats (recursive)
echo "seqkit stats..."
## v1.5
find . -type f -regex '.*\.f\(ast\)?q\.gz' -print0 | xargs -0 seqkit stats --all -j ${CPU_THREAD} > seqkit_stats.txt &
wait
echo "All Done!"
