#!/bin/bash

############################################
#       NGS Data Stat Pipeline v1.6        #
#         Hongjiang Liu, 07/30/25          #
############################################

# Define ANSI color codes
# Red for errors
RED='\033[0;31m'
# Green for success/completion messages
GREEN='\033[0;32m'
# Yellow for warnings or ongoing processes
YELLOW='\033[0;33m'
# No Color - resets text color
NC='\033[0m'

# MD5 & seqkit stats

# CPU threads (default = max/2)
CPU_THREAD_MAX=$(grep -c '^processor' /proc/cpuinfo)
CPU_THREAD=$((CPU_THREAD_MAX / 2))

## Including .fq .fastq .fq.gz .fastq.gz

## gzip .fasta & .fq into .fasta.gz & .fq.gz
echo -e "${YELLOW}Compressing .fq and .fastq files...${NC}"
if command -v pigz &>/dev/null; then
    find . -type f \( -iname "*.fq" -o -iname "*.fastq" \) -exec pigz --processes ${CPU_THREAD} {} +
else
    find . -type f \( -iname "*.fq" -o -iname "*.fastq" \) -exec gzip {} +
fi

if [ ! "$(command -v seqkit)" ]; then
    echo -e "${RED}ERROR: Seqkit not found. Please install it to proceed.${NC}" >&2
    exit 1
fi

# MD5 checksums
echo -e "${YELLOW}Calculating MD5 checksums...${NC}"
find . -type f -regex '.*\.f\(ast\)?q\.gz' -print0 | xargs -0 -P ${CPU_THREAD} -I {} sh -c 'md5sum "{}"' | sort -k 2 > md5_checksums.txt

# SHA256 checksums
echo -e "${YELLOW}Calculating SHA256 checksums...${NC}"
find . -type f -regex '.*\.f\(ast\)?q\.gz' -print0 | xargs -0 -P ${CPU_THREAD} -I {} sh -c 'sha256sum "{}"' | sort -k 2 > sha_checksums.txt

# seqkit stats (recursive)
echo -e "${YELLOW}Running seqkit stats...${NC}"
find . -type f -regex '.*\.f\(ast\)?q\.gz' -print0 | xargs -0 seqkit stats --all -j ${CPU_THREAD} | sort -k 1 > seqkit_stats.txt

echo -e "${GREEN}All Done! Check md5_checksums.txt, sha_checksums.txt, and seqkit_stats.txt for results.${NC}"
